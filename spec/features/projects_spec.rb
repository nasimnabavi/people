require 'spec_helper'

describe 'Projects page', js: true do
  let!(:dev_role) { create(:role, name: 'developer', technical: true) }
  let!(:pm_role) { create(:role, name: 'pm') }
  let!(:qa_role) { create(:role, name: 'qa') }
  let!(:active_project) { create(:project) }
  let!(:potential_project) { create(:project, :potential) }
  let!(:archived_project) { create(:project, :archived) }
  let!(:potential_archived_project) { create(:project, :potential, :archived) }
  let!(:admin_user) { create(:user, :admin, primary_role: dev_role) }
  let!(:pm_user) { create(:user, primary_role: pm_role) }
  let!(:qa_user) { create(:user, primary_role: qa_role) }
  let!(:dev_position) { create(:position, :primary, user: admin_user, role: dev_role) }
  let!(:pm_position) { create(:position, :primary, user: pm_user, role: pm_role) }
  let!(:qa_position) { create(:position, :primary, user: qa_user, role: qa_role) }
  let!(:note) { create(:note) }

  before do
    allow_any_instance_of(SendMailJob).to receive(:perform)
    page.set_rack_session 'warden.user.user.key' => User
      .serialize_into_session(admin_user).unshift('User')

    visit '/dashboard' # Projects tab
  end

  describe 'tabs' do
    it 'has Active/Potential/Archived tabs' do
      within(find('.projects-types')) do
        page.find('li.active').click
        page.find('li.potential').click
        page.find('li.archived').click
      end
    end
  end

  describe 'project row' do
    context 'when on Active tab' do
      before do
        within(find('.projects-types')) do
          page.find('li.active').click
          wait_for_ajax
        end
      end

      it 'displays action icon (archive) when hovered' do
        expect(page.find('.archive')).to be_visible
      end

      it 'displays proper projects' do
        expect(page).to have_content(active_project.name)
        expect(page).not_to have_content(potential_project.name)
        expect(page).not_to have_content(archived_project.name)
        expect(page).not_to have_content(potential_archived_project.name)
      end

      it 'allows adding memberships to an active project' do
        expect(page).to have_selector('.Select-placeholder')
      end

      describe 'show next' do
        let!(:future_membership) do
          create(:membership, starts_at: 1.month.from_now, user: admin_user)
        end

        context 'when checked' do
          it 'shows future memberships' do
            visit '/dashboard'
            check 'show-next'
            expect(page).to have_content(future_membership.user.last_name)
            expect(page).not_to have_css '.invisible'
          end
        end

        context 'when unchecked' do
          xit 'does not show future memberships' do
            visit '/dashboard'
            uncheck 'show-next'
            invisible_memberships = all('.invisible', visible: false)
            expect(invisible_memberships.size).to eq 1
          end
        end
      end

      describe 'people in project' do
        let!(:project_membership) { create(:membership, project: active_project) }
        let!(:future_project_membership) do
          create(:membership, project: active_project, starts_at: Time.now + 2.weeks)
        end

        it 'shows number of present people in project' do
          visit '/dashboard'
          non_billable_count = find('.non-billable .count')
          expect(non_billable_count).to have_content('1')
        end
      end
    end

    context 'when on Potential tab' do
      before do
        page.find('li.potential').click
        wait_for_ajax
      end

      it 'displays action icon (archive) when hovered' do
        expect(page.find('.archive')).to be_visible
      end

      it 'displays proper projects' do
        page.find('li.potential').click
        expect(page).not_to have_content(active_project.name)
        expect(page).to have_content(potential_project.name)
        expect(page).not_to have_content(archived_project.name)
        expect(page).not_to have_content(potential_archived_project.name)
      end

      it 'allows adding memberships to a potential project' do
        expect(page).to have_selector('.Select-placeholder')
      end
    end

    context 'when on Archived tab' do
      before do
        page.find('li.archived').click
        wait_for_ajax
      end

      it 'displays all archived projects' do
        expect(page.find_link(archived_project.name)).to be_visible
        expect(page.find_link(potential_archived_project.name)).to be_visible
      end

      it 'does not display active and potential non-archived projects' do
        expect(page).not_to have_content(active_project.name)
        expect(page).not_to have_content(potential_project.name)
      end

      it 'displays action icon (unarchive) when hovered' do
        expect(page).to have_selector('.unarchive')
      end

      it 'does not allow adding memberships to an archived project' do
        within('#projects-users') do
          expect(page).to have_no_selector('.Select-placeholder')
        end
      end
    end
  end

  describe 'project adding' do
    before { visit new_project_path }

    context 'when adding a valid project' do
      context 'with complete data' do
        it 'creates a new project' do
          fill_in('project_name', with: 'Project1')
          fill_in('project_kickoff', with: Date.today)
          fill_in('project_end_at', with: Date.parse(1.year.from_now.to_s))
          check('Potential')
          find('.btn-success').click

          expect(page).to have_content('Project1')
        end
      end
    end

    context 'when adding invalid project' do

      context 'when name is not present' do
        it 'fails with error message' do
          find('.btn-success').click
          expect(page).to have_content('can\'t be blank')
        end
      end
    end
  end

  describe 'project editing' do
    let(:project) { create(:project) }
    before { visit edit_project_path(project) }

    it 'allows to edit project' do
      check('Synchronize with profile?')
      fill_in('project_name', with: 'Edited project')
      fill_in('project_kickoff', with: Date.today)
      fill_in('project_end_at', with: Date.parse(1.year.from_now.to_s))
      find('.btn-success').click
      expect(page).to have_content('Edited project')
    end
  end

  describe 'managing people in project' do
    describe 'adding member to project' do
      xit 'adds member to project correctly' do
        within('.projects-types') do
          find('li.active').click
        end

        within('.project') do
          find('.Select-placeholder').click
          find('.Select-menu-outer').click
        end

        billable_count = find('.billable .count')
        expect(billable_count).to have_content('1')
      end
    end

    describe 'removing member from project' do
      let!(:membership) { create(:membership, user: pm_user, project: active_project) }

      before { visit '/dashboard' }

      # The issue with this test is that Poltergeist driver relies on PhantomJS < 2.0
      # which in turn does not support sending request body with PATCH, which in turn
      # is the method for update action in Backbone.js. This is to be updated when the
      # 'phantomjs' gem starts supporting the 2.0 version.

      xit 'removes member from project correctly' do
        within('#filters') do
          find('.projects-types li.active').click
        end

        within('div.project') do
          find('.icons span.remove', visible: false).click
        end

        expect(find('div.project div.non-billable')).to have_no_selector('div.membership')
      end
    end
  end

  describe 'managing notes' do
    describe 'add a new note' do
      before do
        find('.projects-types li.active').click
        find('.show-notes').click
      end

      it 'add a note to the project' do
        expect(page).not_to have_selector('div.note-group')
        find('input.new-project-note-text').set('Test note')
        find('a.new-project-note-submit').click
        expect(page.find('div.note-group', text: 'Test note')).to be_visible
      end
    end

    describe 'remove note' do
      before do
        create(:note, user: pm_user, project: active_project)
        find('.projects-types li.active').click
        find('.show-notes').click
      end

      it 'remove a note' do
        expect(page).to have_selector('div.note-group')
        expect(page).to have_content(note.text)
        find('span.note-remove').click
        expect(page).not_to have_selector('div.note-group')
        expect(page).not_to have_content(note.text)
      end
    end
  end
end

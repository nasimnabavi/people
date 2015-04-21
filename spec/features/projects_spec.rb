require 'spec_helper'

describe 'Projects page', js: true do
  let!(:dev_role) { create(:role, name: 'developer', technical: true) }
  let!(:pm_role) { create(:role, name: 'pm') }
  let!(:qa_role) { create(:role, name: 'qa') }
  let!(:active_project) { create(:project) }
  let!(:potential_project) { create(:project, :potential) }
  let!(:archived_project) { create(:project, :archived) }
  let!(:admin_user) { create(:user, :admin, primary_role: dev_role) }
  let!(:pm_user) { create(:user, primary_role: pm_role) }
  let!(:qa_user) { create(:user, primary_role: qa_role) }
  let!(:dev_position) { create(:position, user: admin_user, role: dev_role) }
  let!(:pm_position) { create(:position, user: pm_user, role: pm_role) }
  let!(:qa_position) { create(:position, user: qa_user, role: qa_role) }
  let!(:note) { create(:note) }

  before do
    allow_any_instance_of(SendMailJob).to receive(:perform)
    page.set_rack_session 'warden.user.user.key' => User
      .serialize_into_session(admin_user).unshift('User')

    visit '/dashboard' # Projects tab
  end

  describe 'tabs' do
    it 'has Active/Potential/Archived tabs' do
      within('#filters') do
        page.find('li.active').click
        page.find('li.potential').click
        page.find('li.archived').click
      end
    end
  end

  describe 'project row' do
    context 'when on Active tab' do
      it 'displays action icons (timelapse) when hovered' do
        within('#filters') { page.find('li.active').click }

        within('.project') do
          expect(page.find('.unarchive', visible: false)).to_not be_visible
          expect(page.find('.archive')).to be_visible
          expect(page.find('.info.js-timeline-show')).to be_visible
        end
      end
    end

    context 'when on Potential tab' do
      it 'displays action icons (archive, timelapse) when hovered' do
        page.find('li.potential').click
        within('.project.potential') do
          expect(page.find('.unarchive', visible: false)).to_not be_visible
          expect(page.find('.archive')).to be_visible
          expect(page.find('.info.js-timeline-show')).to be_visible
        end
      end
    end

    context 'when on Archived tab' do
      it 'displays action icons (unarchive, timelapse) when hovered' do
        page.find('li.archived').click
        within('.project.archived') do
          expect(page.find('.unarchive')).to be_visible
          expect(page.find('.archive', visible: false)).to_not be_visible
          expect(page.find('.info.js-timeline-show')).to be_visible
        end
      end
    end
  end

  describe 'project adding' do
    before do
      find('button.new-project-add').click
    end

    context 'when adding a valid project' do
      context 'with complete data' do
        xit 'creates a new project' do
          find_by_id('project-name').set('Project1')
          find_by_id('project-slug').set('test')
          fill_in('kickoff', with: Date.today)
          fill_in('end-at', with: Date.parse(1.year.from_now.to_s))
          check('Potential')
          find('div.selectize-control.devs .selectize-input').click
          first('div.selectize-dropdown-content [data-selectable]', wait: 5).click
          find('div.selectize-control.pms .selectize-input').click
          first('div.selectize-dropdown-content [data-selectable]', wait: 5).click
          find('div.selectize-control.qas .selectize-input').click
          first('div.selectize-dropdown-content [data-selectable]', wait: 5).click
          find('button.new-project-submit').click

          expect(page).to have_content('Project1', wait: 10)
        end
      end

      context 'with no kickoff date provided' do
        xit 'correctly displays the project added' do
          find_by_id('project-name').set('Project1')
          find('div.selectize-control.devs .selectize-input').click
          first('div.selectize-dropdown-content [data-selectable]', wait: 5).click
          find('button.new-project-submit').click

          within('#filters') { page.find('li.active').click }

          expect(page).to have_content(admin_user.last_name, wait: 10)
          expect(page).to have_selector('div.member-name')
        end
      end

      context 'with a kickoff date provided' do
        xit 'correctly displays the project added' do
          find_by_id('project-name').set('Project1')
          fill_in('kickoff', with: Date.today.next_month)
          find('div.selectize-control.devs .selectize-input').click
          first('div.selectize-dropdown-content [data-selectable]', wait: 5).click
          find('button.new-project-submit').click

          within('#filters') { page.find('li.active').click }

          expect(page).to have_content(admin_user.last_name, wait: 10)
          expect(find('div.project div.non-billable div.member-details'))
            .to have_content("From #{Date.today.next_month.strftime('%d.%m')}")
        end
      end
    end

    context 'when adding invalid project' do

      context 'when name is invalid' do
        xit 'fails with error message' do
          find_by_id('project-name').set('test test')
          find_by_id('project-slug').set('test')
          find('button.new-project-submit').click
          expect(page.find('.message-error')).to be_visible
        end
      end

      context 'when slug is invalid' do
        xit 'fails with message error' do
          find_by_id('project-name').set('test')
          find_by_id('project-slug').set('tEsT')
          find('button.new-project-submit').click
          expect(page.find('.message-error')).to be_visible
        end
      end
    end
  end

  describe 'managing people in project' do
    describe 'adding member to project' do
      it 'adds member to project correctly' do
        within('#filters') do
          find('.projects-types li.active').click
        end

        within('div.project') do
          find('div.selectize-input.items').click
          first('.selectize-dropdown.multi [data-selectable]').click
        end

        expect(find('div.project div.non-billable div.count')).to have_text('1')
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
        within('div.project') do
          first('div.show-notes').click
        end
      end

      it 'add a note to the project' do
        find('input.new-project-note-text').set('Test note')
        find('a.new-project-note-submit').click
        expect(page.find('div.scroll-overflow', text: 'Test note')).to be_visible
      end
    end

    describe 'remove note' do

      before do
        create(:note, user: pm_user, project: active_project)
        visit '/dashboard'
        find('.projects-types li.active').click
        within('div.project') do
          first('div.show-notes').click
        end
      end

      it 'remove a note' do
        expect(page.find('div.scroll-overflow', text: note.text)).to be_visible
        find('span.note-remove').click
        expect(page.find('.alert-success')).to be_visible
      end
    end
  end
end

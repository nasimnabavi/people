require 'spec_helper'

describe 'team view', js: true do
  let(:admin_user) { create(:user, :admin) }
  let(:billable_role) { create(:role_billable) }
  let(:non_dev_role) { create(:role, name: 'junior qa') }
  let(:hidden_role) { create(:role, show_in_team: false) }
  let(:team) { create(:team) }
  let!(:dev_role) { create(:role, name: 'developer') }
  let!(:junior_role) { create(:role, name: 'junior', billable: false) }

  let!(:dev_user) do
    create(:user, :admin, first_name: 'Developer Daisy', primary_role: billable_role)
  end

  let!(:non_dev_user) do
    create(:user, first_name: 'Nondev Nigel', primary_role: non_dev_role)
  end

  let!(:archived_user) do
    create(:user, first_name: 'Archived Arthur', archived: true)
  end

  let!(:no_role_user) { create(:user, first_name: 'Norole Nicola') }

  let!(:hidden_user) do
    create(:user, first_name: 'Hidden Amanda', primary_role: hidden_role,
      team_id: team.id)
  end

  let!(:team_user) do
    create(:user, first_name: 'Developer Dave', primary_role: billable_role,
      team_id: team.id)
  end

  let!(:junior_team_user) do
    create(:user, first_name: 'Junior Jake', primary_role: junior_role,
      team_id: team.id)
  end

  before(:each) do
    page.set_rack_session 'warden.user.user.key' => User
      .serialize_into_session(admin_user).unshift('User')

    visit '/teams'
  end

  describe '.show-users button' do
    before(:each) do
      find('.show-users').click
    end

    it "doesn't show archived users" do
      expect(page).not_to have_content archived_user.first_name
    end

    it 'shows only users with roles chosen by admin' do
      expect(page).not_to have_content hidden_user.first_name
    end
  end

  describe '.new-team-add' do
    before(:each) do
      find('.new-team-add').click
    end

    it 'shows new team form' do
      expect(page).to have_css('.js-new-team-form')
      expect(page).to have_content 'Add team'
    end

    it 'adds new team' do
      expect(Team.count).to eq 1
      find('.js-new-team-form .form-control.name').set('teamX')
      find('a.new-team-submit').click
      expect(page).to have_content 'teamX has been created'
      expect(Team.count).to eq 2
    end
  end

  describe '.js-promote-leader' do
    xit 'promotes member to leader' do
      find('.js-promote-leader', match: :first).click
      expect(page).not_to have_css('ul.team-members.empty')
      expect(page).to have_css('ul.team-members.filled')
      msg = "We successfully promoted #{team_user.decorate.name} to the leader of #{team.name}!"
      expect(page).to have_content(msg)
    end
  end

  describe '.js-edit-team' do
    before(:each) do
      find('.js-edit-team').click
    end

    it 'shows edit form' do
      expect(page).to have_content('New name')
    end

    it 'updates team name' do
      find('input.new-name').set('Relatively OK team')
      find('button.js-edit-team-submit').click
      expect(page).to have_content('Relatively OK team')
    end
  end

  describe '.js-team-member-new' do
    it 'is not visible for non-admin user' do
      page.set_rack_session 'warden.user.user.key' => User
        .serialize_into_session(dev_user).unshift('User')

      expect(page).not_to have_css('div.js-team-member-new')
    end

    it 'is visible for admin user' do
      expect(page).to have_css('div.js-team-member-new')
    end
  end

  describe '.js-number-of-days' do
    # temporary xited
    xit 'displays time spent in the team' do
      team_user.update_attribute(:team_join_time, Time.now - 3.days)

      visit current_path
      sleep(2)
      expect(first(:css, ".js-number-of-days").text).to have_content('Since: 3 days')
    end
  end

  describe '.devs-indicator' do
    it 'shows number of users in team' do
      indicator = first('.devs-indicator')
      devs_indicator = indicator.first('.devs').text
      jnrs_indicator = indicator.first('.jnrs').text
      expect(devs_indicator).to eq '1'
      expect(jnrs_indicator).to eq '1'
    end
  end
end

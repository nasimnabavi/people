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
  let!(:dev_position) { create(:position, :primary, user: dev_user, role: billable_role) }

  let!(:non_dev_user) do
    create(:user, first_name: 'Nondev Nigel', primary_role: non_dev_role)
  end
  let!(:non_dev_position) { create(:position, :primary, user: non_dev_user, role: non_dev_role) }

  let!(:archived_user) do
    create(:user, first_name: 'Archived Arthur', archived: true)
  end

  let!(:no_role_user) { create(:user, first_name: 'Norole Nicola') }

  let!(:hidden_user) do
    create(:user, first_name: 'Hidden Amanda', primary_role: hidden_role,
      teams: [team])
  end
  let!(:hidden_user_position) { create(:position, :primary, user: hidden_user, role: hidden_role) }

  let!(:team_user) do
    create(:user, first_name: 'Developer Dave', primary_role: billable_role,
      teams: [team])
  end
  let!(:team_user_position) { create(:position, :primary, user: team_user, role: billable_role) }

  let!(:junior_team_user) do
    create(:user, first_name: 'Junior Jake', primary_role: junior_role,
      teams: [team])
  end
  let!(:junior_user_position) do
    create(:position, :primary, user: junior_team_user, role: junior_role)
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

    xit "doesn't show archived users" do
      expect(page).not_to have_content archived_user.first_name
    end

    xit 'shows only users with roles chosen by admin' do
      expect(page).not_to have_content hidden_user.first_name
    end
  end

  describe '.new-team-add' do
    before(:each) do
      find('.new-team-add').click
    end

    xit 'shows new team form' do
      expect(page).to have_css('.js-new-team-form')
      expect(page).to have_content 'Add team'
    end

    xit 'adds new team' do
      expect(Team.count).to eq 1
      find('.js-new-team-form .form-control.name').set('teamX')
      find('a.new-team-submit').click
      expect(page).to have_content 'teamX has been created'
      expect(Team.count).to eq 2
    end
  end

  describe '.js-promote-leader' do
    let(:promoted_user) { [team_user, junior_team_user].sort_by(&:last_name).first.decorate }
    let(:success_msg) do
      "We successfully promoted #{promoted_user.name} to the leader of #{team.name}!"
    end

    xit 'promotes member to leader' do
      binding.pry
      find('.js-promote-leader', match: :first).click
      expect(page).not_to have_css('ul.team-members.empty')
      expect(page).to have_css('ul.team-members.filled')
      expect(page).to have_content(success_msg)
    end
  end

  describe '.js-edit-team' do
    before(:each) do
      find('.js-edit-team').click
    end

    xit 'shows edit form' do
      expect(page).to have_content('New name')
    end

    xit 'updates team name' do
      new_team_name = 'Relatively OK team'
      find('input.new-name').set(new_team_name)
      find('button.js-edit-team-submit').click
      expect(page).to have_content(new_team_name)
      expect(page).to have_content("We successfully changed team's name to #{new_team_name}")
    end
  end

  describe '.js-team-member-new' do
    context 'when current_user is not an admin' do
      xit 'is not visible' do
        page.set_rack_session 'warden.user.user.key' => User
          .serialize_into_session(dev_user).unshift('User')

        expect(page).not_to have_css('div.js-team-member-new')
      end
    end

    context 'when current_user us an admin' do
      xit 'is visible' do
        expect(page).to have_css('div.js-team-member-new')
      end

      let(:success_msg) do
        "We successfully added #{added_user.name} to #{team.name}!"
      end
      let(:added_user) { [dev_user, non_dev_user].sort_by(&:last_name).first.decorate }

      xit 'adds a new member to the team' do
        expect(page).to have_css('.membership', count: 2)
        find('.js-team-member-new').click
        find('.selectize-dropdown-content > div', match: :first).click
        expect(page).to have_css('.membership', count: 3)
        expect(page).to have_content(success_msg)
      end
    end
  end

  describe '.js-number-of-days' do
    xit 'displays time spent in the team' do
      team_user.update_attribute(:team_join_time, Time.now - 3.days)

      visit current_path
      expect(page).to have_content('Since: 3 days')
    end
  end

  describe '.devs-indicator' do
    xit 'shows number of users in team' do
      indicator = first('.devs-indicator')
      devs_indicator = indicator.first('.devs').text
      jnrs_indicator = indicator.first('.jnrs').text
      expect(devs_indicator).to eq '1'
      expect(jnrs_indicator).to eq '1'
    end
  end
end

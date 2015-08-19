require 'spec_helper'

describe 'Scheduling page', js: true do
  let(:admin_user) { create(:user, :admin) }
  let!(:angular_ability) { create(:ability, name: 'AngularJS') }
  let!(:dev_with_no_skillz) { create(:user) }
  let!(:angular_dev) { create(:user, abilities: [angular_ability]) }
  let!(:another_dev) { create(:user) }

  before do
    sign_in(admin_user)
    visit scheduling_path
  end

  describe 'filters' do
    xit 'allows to filter by abilities' do
      expect(page).to have_content angular_dev.last_name
      expect(page).to have_content dev_with_no_skillz.last_name

      select_option('abilities', 'AngularJS')
      expect(page).to have_content angular_dev.last_name
      expect(page).to_not have_content dev_with_no_skillz.last_name
    end

    xit 'allows to filter by availability time' do
      select_option('availability_time', 'From now')

      expect(page).to have_content angular_dev.last_name
      expect(page).to have_content dev_with_no_skillz.last_name
      expect(page).not_to have_content another_dev.last_name
    end

    xit 'allows to display all users after selecting from now' do
      expect(page).to have_content another_dev.last_name

      select_option('availability_time', 'From now')

      expect(page).to have_content angular_dev.last_name
      expect(page).to have_content dev_with_no_skillz.last_name
      expect(page).not_to have_content another_dev.last_name

      select_option('availability_time', 'All')

      expect(page).to have_content another_dev.last_name
    end
  end

  describe 'table with users' do
    let!(:pm_role) { create(:pm_role) }
    let!(:pm) { create(:user, primary_role: pm_role) }

    xit 'displays users' do
      expect(page).to have_content another_dev.last_name
    end

    xit 'displays only technical users' do
      expect(page).not_to have_content pm.last_name
    end
  end
end

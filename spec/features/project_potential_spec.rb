require 'spec_helper'

describe 'Potential project', js: true do
  let!(:project) { create :project, :potential }
  let!(:admin_user) { create :user, :admin }
  let!(:user) { create :user }

  before do
    page.set_rack_session 'warden.user.user.key' => User
      .serialize_into_session(admin_user).unshift('User')
  end

  context 'when stays is false' do
    let!(:membership) { create :membership, project: project, user: user }

    before do
      visit edit_project_path(project)
    end

    it 'shows potential memberships' do
      expect(page).to have_content("#{user.decorate.name} , stays unchecked")
    end

    it 'deletes membership when project is updated to nonpotential' do
      click_button('Save')
      visit user_path(user)
      expect(page).not_to have_content(project.name)
    end
  end

  context 'when stays is true' do
    let!(:membership) { create :membership, project: project, user: user, stays: true }

    before do
      visit edit_project_path(project)
    end

    it 'shows potential memberships' do
      expect(page).to have_content("#{user.decorate.name} , stays checked")
    end

    it 'dont delete membership when project is updated to nonpotential' do
      uncheck('Potential')
      click_button('Save')
      visit user_path(user)
      expect(page).to have_content(project.name)
    end
  end
end

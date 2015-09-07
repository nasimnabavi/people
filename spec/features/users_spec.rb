require "spec_helper"

describe "Users page", js: true do
  let(:role) { create(:role) }
  let(:user) { create(:user) }
  let!(:developer) { create(:user) }
  let!(:position) { create(:position, user: developer, role: role, primary: true) }

  before(:each) do
    page.set_rack_session 'warden.user.user.key' => User.serialize_into_session(user).unshift('User')
    visit '/users'
  end

  it "shows user role" do
    names = developer.primary_roles.pluck(:name).join(', ')
    expect(page).to have_content(names)
  end
end

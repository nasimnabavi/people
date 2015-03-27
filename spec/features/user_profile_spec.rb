require 'spec_helper'

describe 'profile', js: true do
  let(:user) { create(:plain_user) }

  before do
    page.set_rack_session 'warden.user.user.key' => User.serialize_into_session(user).unshift('User')
  end

  describe 'setting primary role' do
    xit 'set primary role to a user' do
    end
  end

  describe 'adding positions' do
    xit 'adds a position to user' do
    end
  end
end

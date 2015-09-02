require 'spec_helper'

describe Api::V2::UsersController do
  describe 'GET #index' do
    let(:token) { AppConfig.api_token }
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    before { get :index, token: token }

    it { expect(response.status).to eq(200) }
    it { expect(json_response.length).to eq(2) }
  end
end

require 'spec_helper'

describe Api::V3::UsersController do
  describe 'GET #technical' do
    let(:token) { AppConfig.api_token }
    let!(:developer) { create(:developer_in_project) }
    let!(:pm) { create(:pm_user) }

    before { get :technical, token: token }

    it { expect(response.status).to eq(200) }
    it { expect(json_response.length).to eq(1) }
  end
end

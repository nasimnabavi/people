require 'spec_helper'

describe Api::V2::StatisticsController do
  describe 'GET #index' do
    context 'without api token' do
      it 'returns response status 403' do
        get :index
        expect(response.status).to eq 403
      end
    end

    context 'with api token' do
      let(:token) { AppConfig.api_token }
      let(:params) do
        { format: :json, token: token, startDate: '2015-10-1', endDate: '2015-10-30' }
      end

      before do
        create(:project, :internal, starts_at: '2015-10-2', end_at: '2015-11-2')
        create(:project, :commercial, starts_at: '2015-10-4', end_at: nil)
        create(:project, :commercial, starts_at: '2015-10-8', end_at: '2015-11-8')
        create(:project, :commercial, :potential, starts_at: Date.today + 5.days)
      end

      context 'without admin' do
        before { sign_in create(:user) }

        it 'returns response status 403' do
          get :index, params
          expect(response.status).to eq 403
        end
      end

      context 'with admin' do
        render_views

        before do
          sign_in create(:user, :admin)
          get :index, params
        end

        it 'returns response status 200' do
          expect(response.status).to eq 200
        end

        it 'returns proper json' do
          expect(json_response['commercialProjects'].length).to eq 2
          expect(json_response['internalProjects'].length).to eq 1
          expect(json_response['projectsEndingBetween'].length).to eq 0
          expect(json_response['beginningSoonProjects'].length).to eq 1
        end
      end
    end
  end
end

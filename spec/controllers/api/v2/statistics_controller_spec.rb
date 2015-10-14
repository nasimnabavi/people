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
      let(:statistics) do
        {
          "commercialProjectsNumber" => 2,
          "internalProjectsNumber" => 1,
          "projectsEndingThisMonthNumber" => 0,
          "beginningNextMonthProjectsNumber" => 1,
          "billableDevelopersNumber" => 0,
          "developersInInternalsNumber" => 0,
          "juniorsAndInternsNumber" => 0
        }
      end

      before do
        create(:project, :internal, starts_at: '2015-10-2', end_at: '2015-11-2')
        create(:project, :commercial, starts_at: '2015-10-4', end_at: nil)
        create(:project, :commercial, starts_at: '2015-10-8', end_at: '2015-11-8')
        create(:project, :commercial, :potential, starts_at: '2015-11-7', end_at: '2015-12-30')
      end

      context 'without admin' do
        before { sign_in create(:user) }

        it 'returns response status 403' do
          get :index, token: token, date: '2015-10-1'
          expect(response.status).to eq 403
        end
      end

      context 'with admin' do
        before do
          sign_in create(:user, :admin)
          get :index, token: token, date: '2015-10-1'
        end

        it 'returns response status 200' do
          expect(response.status).to eq 200
        end

        it 'returns proper json' do
          expect(json_response).to eq statistics
        end
      end
    end
  end
end

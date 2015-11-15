require 'spec_helper'

describe Api::V2::StatisticsController do
  let!(:internal) { create(:project, :internal, starts_at: '2015-10-2', end_at: '2015-11-2') }
  let!(:commercial_unfinished) do
    create(:project, :commercial, starts_at: '2015-10-4', end_at: nil)
  end
  let!(:commerical_with_end_date) do
    create(:project, :commercial, starts_at: '2015-10-8', end_at: '2015-11-8')
  end
  let!(:commerical_ending) do
    create(:project, :commercial, starts_at: '2015-9-2', end_at: '2015-10-29')
  end
  let!(:potential) do
    create(:project, :commercial, :potential, starts_at: Date.today + 5.days)
  end
  let!(:maintenance) do
    create(:project, :commercial, :maintenance, maintenance_since: '2015-10-9',
      starts_at: '2015-1-1')
  end
  let(:dev) { create(:role, name: 'developer RoR') }
  let!(:internal_membership) do
    create(:membership, project: internal, starts_at: '2015-10-2', ends_at: '2015-11-1',
      role: dev)
  end
  let!(:billable_dev_in_commercial) do
    create(:membership, :billable, project: commercial_unfinished, starts_at: '2015-10-8',
      role: dev)
  end
  let!(:non_billable_membership_in_commercial) do
    create(:membership, project: commercial_unfinished, starts_at: '2015-10-12', role: dev)
  end

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

        it 'exposes statistics' do
          controller.statistics.should be_a StatisticsRepository
        end

        it 'returns response status 200' do
          expect(response.status).to eq 200
        end

        it 'returns proper json' do
          expect(json_response['commercialProjects'].length).to eq 3
          expect(json_response['maintenanceProjects'].length).to eq 1
          expect(json_response['internalProjects'].length).to eq 1
          expect(json_response['projectsEndingBetween'].length).to eq 1
          expect(json_response['beginningSoonProjects'].length).to eq 1
          expect(json_response['developersInInternals'].length).to eq 1
          expect(json_response['nonBillableInCommercialProjects'].length).to eq 1
          expect(json_response['rorDevs'].length).to eq 1
        end
      end
    end
  end
end

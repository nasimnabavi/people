require 'spec_helper'
describe Api::V1::ProjectsController do
  render_views
  before { controller.class.skip_before_filter :authenticate_api! }

  let!(:project1) { create(:project, potential: false) }
  let!(:project2) { create(:project, potential: true) }
  let!(:project3) { create(:project, potential: false, synchronize: false) }
  let(:project_keys) { %w(id name archived potential toggl_bookmark slug) }

  describe 'GET #index' do
    before do
      get :index, format: :json
    end

    it 'returns 200 code' do
      expect(response.status).to eq 200
    end

    it 'contains current_week fields' do
      expect(json_response.first.keys).to eq(project_keys)
    end

    it 'does not return potential projects' do
      expect(json_response.length).to eq(1)
      expect(json_response[0]['name']).to eq(project1.name)
    end

    it 'does not return project which should not be synchronized' do
      expect(json_response.length).to eq(1)
      project_names = json_response.map { |project| project['name'] }
      expect(project_names).not_to include project3.name
    end
  end
end

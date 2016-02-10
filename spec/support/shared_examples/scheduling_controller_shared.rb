shared_examples 'user is an admin and response is 200' do |action|
  let!(:developer) { create(:developer_in_project) }
  let!(:pm) { create(:pm_user) }

  context 'when current user is an admin' do
    let(:admin_user) { create(:user, :admin) }

    before { sign_in(admin_user) }

    it 'responds successfully with an HTTP 200 status code' do
      get action
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end
end

shared_examples 'user is an admin and only technical users are visible' do |action|
  let!(:developer) { create(:developer_in_project) }
  let!(:pm) { create(:pm_user) }

  context 'when current user is an admin' do
    let(:admin_user) { create(:user, :admin) }
    before { sign_in(admin_user) }

    it 'displays users on view' do
      get action
      expect(response.body).to include(developer.last_name)
      expect(response.body).not_to include(pm.last_name)
    end
  end
end

shared_examples 'user is not an admin and response is 200' do |action|
  context 'when current user is not an admin' do
    let(:user) { create(:user) }

    before { sign_in(user) }

    it 'responds successfully with an HTTP 200 status code' do
      get action
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end
end

require 'spec_helper'

describe AvailableUsersController do
  render_views

  describe '#index' do
    let!(:available_user) { create(:user) }
    let!(:unavailable_user) { create(:user) }

    context 'when current user is an admin' do
      let(:available_admin_user) { create(:user, :admin) }

      before { sign_in(available_admin_user) }

      it 'responds successfully with an HTTP 200 status code' do
        get :index
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it 'displays users on view' do
        get :index
        expect(response.body).to match(available_user.last_name)
        expect(response.body).to match(available_user.last_name)
        expect(response.body).not_to match(unavailable_user.last_name)
      end
    end

    context 'when current user is not an admin' do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it 'redirects user to root path' do
        get :index
        expect(response.status).to eq(302)
        expect(response.redirect_url).to eq(root_url)
      end
    end
  end
end

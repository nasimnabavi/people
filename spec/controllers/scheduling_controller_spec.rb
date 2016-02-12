require 'spec_helper'

describe SchedulingController do
  render_views

  describe '#all' do
    it_behaves_like 'user is an admin and response is 200', :all
    it_behaves_like 'user is an admin and only technical users are visible', :all
    it_behaves_like 'user is not an admin and response is 200', :all
  end


  describe '#not_scheduled' do
    it_behaves_like 'user is an admin and response is 200', :index

    context 'when current user is not an admin redirection occurs' do
      let(:user) { create(:user) }

      before { sign_in(user) }
      it 'responds successfully with an HTTP 302 status code' do
        get :not_scheduled
        expect(response.status).to eq(302)
      end
    end
  end
end

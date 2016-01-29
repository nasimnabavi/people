require 'spec_helper'

describe SendMailWithUserJob do
  let(:mailer) { described_class }
  let(:user) { create(:user) }
  let(:membership) { create(:membership, user: user) }

  describe '#perform' do
    it 'delivers an email' do
      expect do
        mailer.perform_async(MembershipMailer, :created, membership, user.id)
      end.to change { MembershipMailer.deliveries.size }.by(1)
    end
  end
end

require 'spec_helper'

describe SendMailJob do
  let(:mailer) { described_class }

  describe '#perform' do
    it 'delivers an email' do
      expect do
        mailer.perform_async(UserMailer, :notify_operations, 'an email')
      end.to change { UserMailer.deliveries.size }.by(1)
    end
  end
end

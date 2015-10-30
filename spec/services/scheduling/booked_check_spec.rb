require 'spec_helper'

describe Scheduling::BookedCheck do
  let!(:user) { create(:user) }
  let!(:expired_booked_membership) { create(:membership, :booked_expired, user: user) }
  let!(:actual_booked_membership) { create(:membership, :booked, user: user) }


  subject { described_class.new.call }

  describe '#call' do
    it 'removes booked memberships that is outdated' do
      subject
      expect(user.reload.memberships).not_to include(expired_booked_membership)
    end

    it 'leaves booked memberships that are still before expiration date' do
      subject
      expect(user.reload.memberships).to include(actual_booked_membership)
    end
  end
end

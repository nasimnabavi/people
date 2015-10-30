require 'spec_helper'

describe Memberships::UpdateBookedAt do
  let(:membership) { create :membership }
  subject { described_class.new(membership).call }

  describe '#call' do
    context 'booked has changed' do
      context 'to false' do
        before do
          membership.booked = false
        end

        it 'changes booked_at to nil' do
          subject
          expect(membership.booked_at).to eq nil
        end
      end

      context 'to true' do
        before do
          membership.booked = true
        end

        it 'changes booked_at to actual time' do
          subject
          expect(membership.booked_at.utc.to_s).to eq Time.zone.now.utc.to_s
        end
      end
    end

    context 'booked has not changed' do
      it 'does not change booked_at' do
        expect{ subject }.not_to change { membership.reload.booked_at }
      end
    end
  end
end

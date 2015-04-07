require 'spec_helper'

describe MembershipsRepository do
  describe '.upcoming_changes' do
    let(:days) { 30 }
    let!(:membership1) { create(:membership, starts_at: 1.week.from_now) }
    let!(:membership2) { create(:membership, starts_at: 1.week.from_now) }
    let!(:future_membership) do
      create(
        :membership,
        starts_at: 1.year.from_now,
        ends_at: 2.years.from_now
      )
    end

    subject { described_class.new.upcoming_changes(days).to_a.flatten }

    it 'includes 2 upcoming changes' do
      expect(subject).to include membership1, membership2
    end

    it 'does not include other memberships' do
      expect(subject).not_to include future_membership
    end
  end
end

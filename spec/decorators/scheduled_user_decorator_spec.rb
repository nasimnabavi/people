require 'spec_helper'

describe ScheduledUserDecorator do
  describe '#next_current_membership_ends_at' do
    let(:user_without_project) { create(:user, :developer) }
    let(:user_with_due_dates) { create(:user, :developer) }
    let(:user_without_due_dates) { create(:user, :developer) }

    let(:project_0) { create(:project) }
    let(:project_1) { create(:project) }
    let(:project_2) { create(:project) }

    let!(:membership_0) do
      create(:membership, user: user_with_due_dates, project: project_0,
        role: user_with_due_dates.roles.first, ends_at: Time.current + 1.month)
    end
    let!(:membership_1) do
      create(:membership_without_ends_at, user: user_with_due_dates, project: project_1,
        role: user_with_due_dates.roles.first)
    end
    let!(:membership_2) do
      create(:membership, user: user_with_due_dates, project: project_2,
        role: user_with_due_dates.roles.first, ends_at: Time.current + 2.days)
    end
    let!(:membership_without_ends_at) do
      create(:membership_without_ends_at, user: user_without_due_dates, project: project_2,
        role: user_without_due_dates.roles.first)
    end

    it 'returns nil if user does not have any current memberships' do
      expect(described_class.new(user_without_project).next_current_membership_ends_at).to be_nil
    end

    it 'returns date from the membership that is next to end' do
      expect(described_class.new(user_with_due_dates).next_current_membership_ends_at)
        .to eql(membership_2.ends_at)
    end

    it 'returns project end date if current membership ends_at is not specified' do
      expect(described_class.new(user_without_due_dates).next_current_membership_ends_at)
        .to eql(project_2.end_at)
    end
  end
end

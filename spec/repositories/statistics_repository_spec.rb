require 'spec_helper'

describe StatisticsRepository do
  describe '#non_billable_in_commercial_projects' do
    let!(:user) { create(:user, :junior) }
    let!(:potential_project) { create(:project, :commercial, :potential) }
    let!(:archived_project) { create(:project, :commercial, :archived) }
    let!(:membership_in_potential_project) do
      create(:membership, user: user, project: potential_project, role: user.primary_roles.first)
    end
    let!(:membership_in_archived_project) do
      create(:membership, user: user, project: archived_project, role: user.primary_roles.first)
    end
    let(:start_date) { (Date.today - 10.years).to_s }
    let(:end_date) { (Date.today + 10.years).to_s }

    subject { described_class.new(start_date, end_date).non_billable_in_commercial_projects }

    it 'doesnt fetch archived or potential users' do
      expect(subject).to eq []
    end
  end
end

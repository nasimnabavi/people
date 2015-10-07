require 'spec_helper'

describe Notification::Membership::Updated do
  let(:user) { create(:user, :developer) }
  let(:project) { create(:project) }
  let(:membership) { create(:membership, user: user, project: project) }
  let(:membership_without_ends_at) do
    create(:membership_without_ends_at, user: user, project: project)
  end

  describe '#message' do
    it 'returns nil if neither starts_at nore ends_at changed' do
      expect(described_class.new(membership).message).to be_nil
    end

    it 'returns proper string when starts_at and ends_at changed' do
      new_starts_at = membership_without_ends_at.starts_at + 1.day
      new_ends_at = Date.current + 2.days

      expected_notification = "Time span for *#{user.last_name} #{user.first_name}*"\
        " in *#{project.name}* has been changed."\
        "\nStarts at changed from _#{membership_without_ends_at.starts_at}_ to _#{new_starts_at}_."\
        "\nEnds at changed from _not specified_ to _#{new_ends_at}_."

      membership_without_ends_at.starts_at = new_starts_at
      membership_without_ends_at.ends_at = new_ends_at

      expect(described_class.new(membership_without_ends_at).message).to eql(expected_notification)
    end

    it 'returns proper string if only starts_at changed' do
      new_starts_at = membership.starts_at + 1.day

      expected_notification = "Time span for *#{user.last_name} #{user.first_name}*"\
        " in *#{project.name}* has been changed."\
        "\nStarts at changed from _#{membership.starts_at}_ to _#{new_starts_at}_."

      membership.starts_at = new_starts_at

      expect(described_class.new(membership).message).to eql(expected_notification)
    end

    it 'returns proper string if only ends_at changed' do
      new_ends_at = Date.current + 2.days

      expected_notification = "Time span for *#{user.last_name} #{user.first_name}*"\
        " in *#{project.name}* has been changed."\
        "\nEnds at changed from _not specified_ to _#{new_ends_at}_."

      membership_without_ends_at.ends_at = new_ends_at

      expect(described_class.new(membership_without_ends_at).message).to eql(expected_notification)
    end
  end
end

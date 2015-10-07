require 'spec_helper'

describe Notification::Membership::Created do
  let(:user) { build(:user, :developer) }
  let(:project) { build(:project) }
  let(:membership) { build(:membership, user: user, project: project) }
  let(:membership_without_ends_at) do
    build(:membership_without_ends_at, user: user, project: project)
  end

  describe '#message' do
    it 'returns proper string when ends_at value is present' do
      expected_notification = "*#{user.last_name} #{user.first_name}* has been added to"\
      " *#{project.name}* since _#{membership.starts_at}_ to _#{membership.ends_at}_."

      expect(described_class.new(membership).message).to eql(expected_notification)
    end

    it 'returns proper string when ends_at value is not specified' do
      expected_notification = "*#{user.last_name} #{user.first_name}* has been added to"\
      " *#{project.name}* since _#{membership_without_ends_at.starts_at}_."

      expect(described_class.new(membership_without_ends_at).message).to eql(expected_notification)
    end
  end
end

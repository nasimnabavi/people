require 'spec_helper'

describe Notification::Position::Created do
  let(:role) { build(:dev_role) }
  let(:user) { build(:user, :developer) }
  let(:position) { build(:position, role: role, user: user) }
  let(:position_primary) { build(:position, :primary, role: role, user: user) }

  describe '#message' do
    it 'returns proper string for given position object if it is primary' do
      expected_notification = "*#{user.last_name} #{user.first_name}* has been assigned a new role"\
        " (#{role.name}) since _#{position_primary.starts_at.to_s(:ymd)}_."\
        "\nIt has also been marked as a *primary role*."

      expect(described_class.new(position_primary).message).to eql(expected_notification)
    end

    it 'returns proper string for given position object if it is not primary' do
      expected_notification = "*#{user.last_name} #{user.first_name}* has been assigned a new role"\
        " (#{role.name}) since _#{position.starts_at.to_s(:ymd)}_."\

      expect(described_class.new(position).message).to eql(expected_notification)
    end
  end
end

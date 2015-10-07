require 'spec_helper'

describe Notification::Position::Updated do
  let(:dev_role) { create(:dev_role) }
  let(:senior_role) { create(:senior_role) }
  let(:user) { create(:user, :developer) }
  let(:position) { create(:position, role: dev_role, user: user) }
  let(:position_primary) { create(:position, :primary, role: dev_role, user: user) }

  describe '#message' do
    it 'returns nil if neither primary flag nor role changed' do
      expect(described_class.new(position_primary).message).to be_nil
    end

    it 'sends notification with proper message if primary changed to true' do
      expected_notification = "Role _#{dev_role.name}_ has been marked as the *primary role*"\
        " for *#{user.last_name} #{user.first_name}*."

      position.primary = true

      expect(described_class.new(position).message).to eql(expected_notification)
    end

    it 'sends notification with proper message if primary changed to false' do
      expected_notification = "Role _#{dev_role.name}_ has been unchecked as the"\
      " *primary role* for *#{user.last_name} #{user.first_name}*."

      position_primary.primary = false

      expect(described_class.new(position_primary).message).to eql(expected_notification)
    end

    it 'sends notification with proper message if only role changed' do
      expected_notification = "Role _#{senior_role.name}_ has been"\
        " changed from _#{dev_role.name}_ for *#{user.last_name} #{user.first_name}*."

      position_primary.role = senior_role

      expect(described_class.new(position_primary).message).to eql(expected_notification)
    end

    it 'sends notification with proper message if role and primary flag changed' do
      expected_notification = "Role _#{senior_role.name}_ has been unchecked as the *primary role*"\
        " for *#{user.last_name} #{user.first_name}*. _#{senior_role.name}_"\
        " has been also changed from _#{dev_role.name}_."

      position_primary.primary = false
      position_primary.role = senior_role

      expect(described_class.new(position_primary).message).to eql(expected_notification)
    end
  end
end

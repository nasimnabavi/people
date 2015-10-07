module Notification::Position
  class Updated
    attr_reader :position

    delegate :user, :role, to: :position

    def initialize(position)
      @position = position
    end

    def message
      return if !position.primary_changed? && !position.role_id_changed?

      ['Role', primary_toggled_notification, role_changed_notification].compact.join(' ')
    end

    private

    def primary_toggled_notification
      return nil unless position.primary_changed?

      "_#{role.name}_ has been #{position.primary? ? "marked" : "unchecked"}"\
      " as the *primary role* for *#{user.last_name} #{user.first_name}*."
    end

    def role_changed_notification
      return nil unless position.role_id_changed?

      previous_role = Role.select(:name).find(position.changes[:role_id].first)
      notification = ["_#{role.name}_ has been"]
      notification << "also" if position.primary_changed?
      notification << "changed from _#{previous_role.name}_"

      if position.primary_changed?
        notification.join(' ') + '.'
      else
        notification.join(' ') + " for *#{user.last_name} #{user.first_name}*."
      end
    end
  end
end

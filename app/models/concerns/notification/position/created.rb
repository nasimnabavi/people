module Notification::Position
  class Created
    attr_reader :position

    delegate :user, :role, to: :position

    def initialize(position)
      @position = position
    end

    def message
      notification = [
        "*#{user.last_name} #{user.first_name}* has been assigned a new role (#{role.name}) since "\
        "_#{position.starts_at.to_s(:ymd)}_."
      ]
      notification << "It has also been marked as a *primary role*." if position.primary?
      notification.join("\n")
    end
  end
end

module Notification::Membership
  class Updated
    attr_reader :membership

    delegate :user, :project, to: :membership

    def initialize(membership)
      @membership = membership
    end

    def message
      return unless membership.starts_at_changed? || membership.ends_at_changed?

      notification = [
        "Time span for *#{user.last_name} #{user.first_name}* in *#{project.name}* has been changed."
      ]
      notification << "#{field_change_msg(:starts_at)}" if membership.starts_at_changed?
      notification << "#{field_change_msg(:ends_at)}" if membership.ends_at_changed?
      notification.join("\n")
    end

    private

    def field_change_msg(field)
      from, to = membership.send("#{field.to_s}_change")

      msg = "#{field.to_s.humanize} changed from "
      msg += from.nil? ? '_not specified_ to ' : "_#{from.to_s(:ymd)}_ to "
      to.nil? ? msg + '_not specified_.' : msg + "_#{to.to_s(:ymd)}_."
    end
  end
end

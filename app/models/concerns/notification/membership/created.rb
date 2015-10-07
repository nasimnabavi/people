module Notification::Membership
  class Created
    attr_reader :membership

    delegate :user, :project, to: :membership

    def initialize(membership)
      @membership = membership
    end

    def message
      notification = "*#{user.last_name} #{user.first_name}* has been added to *#{project.name}* "\
        "since _#{membership.starts_at.to_s(:ymd)}_"

      if membership.ends_at.present?
        "#{notification} to _#{membership.ends_at.to_s(:ymd)}_."
      else
        "#{notification}."
      end
    end
  end
end

module Scheduling
  module Sorting
    class ByCurrentMembershipStartDate < Base
      def self.node_date(node)
        date = Date.today
        date = node.longest_current_membership.starts_at unless starts_at_set?(node)
        date
      end

      def self.starts_at_set?(user)
        user.longest_current_membership.nil? || user.longest_current_membership.starts_at.nil?
      end
      private_class_method :starts_at_set?, :node_date
    end
  end
end

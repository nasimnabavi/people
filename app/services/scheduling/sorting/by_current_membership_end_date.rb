module Scheduling
  module Sorting
    class ByCurrentMembershipEndDate < Base
      def self.node_date(node)
        date = closest_end_date(node)
        date = closest_project_end_date(node) if date.nil?
        return nil_date if date.nil?
        date
      end

      def self.closest_end_date(node)
        end_dates = node.current_memberships.map(&:ends_at).compact
        end_dates.sort! { |a, b| a <=> b }
        end_dates.first
      end

      def self.closest_project_end_date(node)
        end_dates = node.current_memberships.map(&:project).map(&:end_at).compact
        end_dates.sort! { |a, b| a <=> b }
        end_dates.first
      end

      def self.nil_date
        1.year.from_now
      end
      private_class_method :node_date, :closest_end_date, :closest_project_end_date,
                           :nil_date
    end
  end
end

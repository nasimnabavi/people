module Scheduling
  module Sorting
    class Base
      def self.sort(collection)
        return collection if collection.size < 2
        collection.sort do |node_a, node_b|
          a = node_date(node_a)
          b = node_date(node_b)
          a.to_time.to_i <=> b.to_time.to_i
        end
      end

      def self.node_date(_node)
        rails NotImplementedError
      end

      def self.nil_date
        1.year.from_now
      end

      private_class_method :node_date, :nil_date
    end
  end
end

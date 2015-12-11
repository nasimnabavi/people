module Repositories
  module Mappers
    class Null < Base

      def self.map_record_attributes(attributes)
        attributes
      end

      def self.unmap_record_attributes(attributes)
        attributes
      end

    end
  end
end

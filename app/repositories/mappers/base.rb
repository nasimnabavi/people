module Repositories
  module Mappers
    class Base

      def self.map_entity_attributes(attributes)
        raise NotImplementedError
      end

      def self.map_record_attributes(attributes)
        raise NotImplementedError
      end

    end
  end
end

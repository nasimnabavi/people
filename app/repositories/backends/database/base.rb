module Repositories
  module Backends
    module Database
      class Base

        def all
          database_model_class.all.map { |record| map_record(record) }
        end

        def find(id)
          map_record(database_model_class.find(id))
        end

        def create(entity)
          record = database_model_class.create!(unmap_record_attributes(entity))
          map_record(record)
        end

        def update(entity)
          database_model_class.update(entity.id, unmap_record_attributes(entity))
        end

        def delete(entity)
          database_model_class.destroy(entity.id)
        end

        private

        def database_model_class
          raise NotImplementedError
        end

        def default_entity_class
          raise NotImplementedError
        end

        def default_mapper_class
          Repositories::Mappers::Null
        end

        def map_record(record, entity_class = default_entity_class, mapper_class = default_mapper_class)
          entity_class.new(mapper_class.map_record_attributes(record.attributes))
        end

        def unmap_record_attributes(entity, mapper_class = default_mapper_class)
          mapper_class.unmap_record_attributes(entity.attributes)
        end

      end
    end
  end
end

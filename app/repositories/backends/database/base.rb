module Repositories
  module Backends
    module Database
      class Base

        def all
          database_model_class.all.map(&:map_record)
        end

        def find(id)
          map_record(database_model_class.find(id))
        end

        def create(object)
          record = database_model_class.create!(object.attributes)
          map_record(record)
        end

        def update(object)
          database_model_class.update(object.id, object.attributes)
        end

        def delete(object)
          database_model_class.destroy(object.id)
        end

        private

        def database_model_class
          raise NotImplementedError
        end

        def map_record(object)
          raise NotImplementedError
        end

      end
    end
  end
end

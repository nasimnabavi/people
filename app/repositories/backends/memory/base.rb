module Repositories
  module Backends
    module Memory
      class Base

        def initialize
          @counter = 0
        end

        def all
          storage.values
        end

        def find(id)
          storage.fetch(id)
        end

        def create(object)
          @counter += 1
          object.id = @counter
          storage[@counter] = object
        end

        def update(object)
          storage[object.id] = object
        end

        def delete(object)
          storage.delete(object.id)
        end

        private

        def storage
          @storage ||= {}
        end

      end
    end
  end
end

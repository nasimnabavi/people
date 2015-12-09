module Repositories
  class Base

    attr_reader :backend

    def initialize(backend)
      @backend = backend
    end

    def all
      backend.all
    end

    def find(id)
      backend.find(id)
    end

    def create(object)
      backend.create(object)
    end

    def update(object)
      backend.update(object)
    end

    def delete(object)
      backend.delete(object)
    end

  end
end

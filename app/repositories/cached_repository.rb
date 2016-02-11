class CachedRepository
  def initialize(repository, namespace)
    @namespace = namespace
    @object = repository
  end

  def method_missing(name)
    Rails.cache.fetch("#{namespace}.#{name}") do
      object.public_send(name).to_a.uniq(&:id)
    end
  end

  private

  attr_reader :object, :namespace
end

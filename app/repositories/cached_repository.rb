class CachedRepository
  def initialize(repository)
    @object = repository
  end

  def method_missing(name)
    Rails.cache.fetch("#{object.class.name}.#{name}") do
      object.public_send(name).to_a.uniq(&:id)
    end
  end

  private

  attr_reader :object
end

module CacheKey
  extend ActiveSupport::Concern

  included do
    def self.cache_key
      maximum(:updated_at)
    end
  end
end

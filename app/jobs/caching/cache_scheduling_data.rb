module Caching
  class CacheSchedulingData
    include SuckerPunch::Job

    def perform
      categories.each do |category_name|
        Rails.cache.write(
          category_name,
          repository.public_send(category_name).to_a.uniq(&:id)
        )
      end
    end

    private

    def categories
      @categories ||= Scheduling::ColumnSetsBuilder.new.call.keys
    end

    def repository
      @repository ||= ScheduledUsersRepository.new
    end
  end
end

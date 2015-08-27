module NetguruApi
  class FetchAbilitiesJob
    include SuckerPunch::Job

    def perform
      ActiveRecord::Base.connection_pool.with_connection do
        users_data = NetguruApi::Profile.fetch_users_with_skills
        users_data.each { |user_data| UserAbilitiesUpdater.new(user_data).call }
      end
    end
  end
end

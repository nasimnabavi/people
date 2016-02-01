namespace :netguru_api do
  namespace :profile do
    desc "Fetch user's abilities from profile app"
    task fetch_users_abilities: :environment do
      NetguruApi::FetchAbilitiesJob.perform_async
    end
  end
end

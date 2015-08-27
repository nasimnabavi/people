namespace :netguru_api do
  namespace :profile do
    desc "Fetch user's abilities from profile app"
    task fetch_users_abilities: :environment do
      NetguruApi::FetchAbilitiesJob.new.async.perform
    end
  end
end

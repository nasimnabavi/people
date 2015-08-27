namespace :netguru_api do
  namespace :profile do
    desc "Fetch user's abilities from profile app"
    task fetch_users_abilities: :environment do
      users_data = NetguruApi::Profile.fetch_users_with_skills
      users_data.each { |user_data| UserAbilitiesUpdater.new(user_data).call }
    end
  end
end

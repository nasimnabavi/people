namespace :scheduling do
  desc 'Remove booked memberships that are expired'
  task remove_expired_booked_memberships: :environment do
    Scheduling::BookedCheck.new.call
  end

  desc 'update cached users in scheduling tabs'
  task update_cache: :environment do
    Caching::CacheSchedulingData.new.perform
  end
end

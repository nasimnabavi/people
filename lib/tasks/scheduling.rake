namespace :scheduling do
  desc 'Remove booked memberships that are expired'
  task remove_expired_booked_memberships: :environment do
    Scheduling::BookedCheck.new.call
  end
end

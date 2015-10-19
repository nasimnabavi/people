namespace :projects do
  desc 'Copy kickoff value to starts_at'
  task kickoff_to_starts_at: :environment do
    Project.where('kickoff is NOT NULL AND starts_at is NULL').update_all('starts_at = kickoff')
  end
end

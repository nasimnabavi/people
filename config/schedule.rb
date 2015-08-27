# Since Rails is not initialized in whenever job file
# it's necessary to manualy require config yml files
ENV['RAILS_ENV'] ||= @environment
require './config/preinitializer'

changes_digest_day = AppConfig.emails.notifications.changes_digest.weekday.to_sym

set :output, 'log/whenever.log'

every changes_digest_day, at: '8 am' do
  rake 'mailer:changes_digest'
end

every 1.day, at: '8 am' do
  rake 'people:gravatars_download'
end

if AppConfig.trello.enabled
  every 1.day, at: '6:00 am' do
    rake 'trello:board_sync'
  end
end

if Flip.fetching_abilities?
  every 1.day at: '12pm' do
    rake 'abilities:update_name_downcase'
  end
end

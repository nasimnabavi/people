namespace :slack do
  desc 'Slack notifications about users that are in the project more than six months'
  task users_with_rotation_need: :environment do
    ScheduledUsersRepository.new.to_rotate.each do |user|
      long_memberships = user.current_memberships.select do |membership|
        membership.starts_at < 6.months.ago
      end

      long_memberships.each do |membership|
        SlackNotifier.new.ping %/
          Rotation for *#{user.first_name} #{user.last_name}* should be planned. Developer has been
          in a project *#{membership.project.name}* for _#{membership.duration_in_months}_ months.
        /.strip.gsub(/\s{2,}/, ' ')
      end
    end
  end
end

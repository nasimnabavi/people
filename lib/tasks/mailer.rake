namespace :mailer do
  task ending_projects: :environment do
    ProjectDigest.ending_in_a_week.each do |project|
      SendMailJob.new.async.perform(ProjectMailer, :ending_soon, project)
    end
  end

  task three_months_old: :environment do
    ProjectDigest.three_months_old.each do |project|
      SendMailJob.new.async.perform(ProjectMailer, :three_months_old, project)
    end
  end

  task kickoff_tomorrow: :environment do
    ProjectDigest.starting_tomorrow.each do |project|
      SendMailJob.new.async.perform(ProjectMailer, :kickoff_tomorrow, project)
    end
  end

  desc 'Email about users that are in the project more than six months'
  task users_to_rotate: :environment do
    ScheduledUsersRepository.new.to_rotate.each do |user|
      long_memberships = user.current_memberships.select do |membership|
        membership.starts_at < 6.months.ago
      end

      long_memberships.each do |membership|
        SendMailJob.new.async.perform(UserMailer, :notify_membership_duration, user, membership)
      end
    end
  end

  desc 'Email upcoming changes to projects'
  task changes_digest: :environment do
    digest_days = AppConfig.emails.notifications.changes_digest
    ProjectDigest.upcoming_changes(digest_days).each do |project|
      SendMailJob.new.async.perform(ProjectMailer, :upcoming_changes, project, digest_days)
    end
  end
end

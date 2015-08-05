namespace :people do
  desc "Download user's gravatars"
  task gravatars_download: :environment do
    User.pluck(:id).each do |user_id|
      GravatarDownloaderJob.new.perform(user_id)
    end
  end

  desc "Update_primary role"
  task primary_role_update: :environment do
    User.each do |user|
      user.primary_role = user.role
      user.save
    end
  end

  desc "Reset primary_role"
  task primary_role_reset: :environment do
    User.update_all(primary_role_id: nil)
  end
end

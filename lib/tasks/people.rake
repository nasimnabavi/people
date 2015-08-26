namespace :people do
  desc "Download user's gravatars"
  task gravatars_download: :environment do
    User.pluck(:id).each do |user_id|
      GravatarDownloaderJob.new.perform(user_id)
    end
  end

  desc "Update primary_roles"
  task primary_roles_update: :environment do
    User.active.each do |user|
      user.positions.find_by(role_id: user.primary_role.id).update_attribute(:primary, true)
    end
  end

  desc "Reset primary_role"
  task primary_role_reset: :environment do
    User.update_all(primary_role_id: nil)
  end
end

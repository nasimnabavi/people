class BaseMailer < ActionMailer::Base
  default from: AppConfig.emails.from

  def mail_receivers(current_user, user=nil)
    (AppConfig.emails.admin + [user.try(:email)] - [current_user.email]).compact
  end
end

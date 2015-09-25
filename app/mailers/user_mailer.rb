class UserMailer < BaseMailer
  def notify_operations(email)
    @email = email
    to = AppConfig.emails.support
    mail(to: to, subject: "New user in the application.", email: @email)
  end

  def notify_membership_duration(user, membership)
    @user = user
    @membership = membership
    to = AppConfig.emails.admin
    subject = if membership.duration_in_months > 5
                "Rotation for #{user.first_name} #{user.last_name} should be planned."
              else
                "#{user.first_name} #{user.last_name} membership duration."
              end
    mail(to: to, subject: subject)
  end
end

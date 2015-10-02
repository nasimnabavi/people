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
    mail(to: to, subject: membership_duration_subject)
  end

  def notify_admins_about_changes(user, current_user)
    @user = user
    @current_user = current_user
    to = AppConfig.emails.admin
    mail(to: to, subject: "#{user.first_name} #{user.last_name} updated.")
  end

  def without_primary_role(users)
    @users = UserDecorator.decorate_collection(users)
    to = AppConfig.emails.admin
    mail(to: to, subject: 'List of users without primary role set.')
  end

  private

  def membership_duration_subject
    if @membership.duration_in_months > 5
      "Rotation for #{@user.first_name} #{@user.last_name} should be planned."
    else
      "#{@user.first_name} #{@user.last_name} membership duration."
    end
  end
end

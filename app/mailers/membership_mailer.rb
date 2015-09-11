class MembershipMailer < BaseMailer
  def created(membership, current_user)
    @user = membership.user.decorate
    @project = membership.project
    @since = membership.starts_at
    @current_user = current_user.decorate
    to = mail_receivers(current_user, @user)
    subject = "#{@user.name} has been added to #{@project.name}"
    mail(to: to, subject: subject, project: @project)
  end

  def updated(data, current_user)
    @membership = data[:membership]
    @user = @membership.user.decorate
    @project = @membership.project
    @old_values = data[:old_values]
    @current_user = current_user.decorate
    to = mail_receivers(current_user, @user)
    subject = "Time span for #{@user.name} in #{@project.name} has been changed"
    mail(to: to, subject: subject, project: @project)
  end
end

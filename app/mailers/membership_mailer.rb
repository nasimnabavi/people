class MembershipMailer < BaseMailer
  def created(membership, current_user)
    @user = membership.user.decorate
    @project = membership.project
    @since = membership.starts_at
    to = mail_receivers(current_user, @user)
    mail(to: to, subject: "#{@user.name} has been added to #{@project.name}", project: @project)
  end

  def updated(data, current_user)
    @membership = data[:membership]
    @user = @membership.user.decorate
    @project = @membership.project
    @old_values = data[:old_values]
    to = mail_receivers(current_user, @user)
    mail(to: to, subject: "Time span for #{@user.name} in #{@project.name} has been changed", project: @project)
  end

end

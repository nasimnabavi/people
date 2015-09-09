class MembershipMailer < BaseMailer
  def created(membership, current_user)
    @user = membership.user.decorate
    @project = membership.project
    @since = membership.starts_at
    to = mail_receivers(current_user, @user)
    mail(to: to, subject: "#{@user.name} has been added to #{@project.name}", project: @project)
  end

end

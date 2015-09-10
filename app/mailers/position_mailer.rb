class PositionMailer < BaseMailer
  def new_position(position, current_user)
    @user = position.user.decorate
    @role = position.role.name
    @since = position.starts_at.to_date
    @primary = position.primary
    to = mail_receivers(current_user, position.user)
    subject = "#{@user.name} has been assigned a new role - #{@role}"
    mail(to: to, subject: subject, project: @project)
  end

  def new_primary(position, current_user)
    @user = position.user.decorate
    @role = position.role.name
    to = mail_receivers(current_user, position.user)
    subject = "New primary role for #{@user.name}"
    mail(to: to, subject: subject, project: @project)
  end
end

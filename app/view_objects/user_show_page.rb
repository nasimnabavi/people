class UserShowPage
  attr_accessor :user, :projects_repository, :user_projects_repository

  def initialize(user:, projects_repository:, user_projects_repository:)
    self.user = UserDecorator.new user
    self.user_projects_repository = user_projects_repository
    self.projects_repository = projects_repository
  end

  def user_gravatar
    return if user.gravatar.nil?
    user.gravatar_image class: 'img-rounded', alt: user.name
  end

  def projects_with_notes
    projects_repository.with_notes
  end

  def user_active_memberships
    MembershipDecorator.decorate_collection(
      user.object.memberships.active.includes(:project).reorder(ends_at: :desc, starts_at: :desc)
    )
  end

  def user_archived_memberships
    MembershipDecorator.decorate_collection(
      user.object.memberships.archived.includes(:project).reorder(ends_at: :desc, starts_at: :desc)
    )
  end

  def user_booked_memberships
    MembershipDecorator.decorate_collection(
      user.object.memberships.booked
        .where("memberships.ends_at IS NULL OR memberships.ends_at > ?", Time.current)
        .includes(:project).reorder(ends_at: :desc, starts_at: :desc)
    )
  end

  def user_active_projects
    user_projects_repository.active_with_memberships.map do |project, ms|
      [project, MembershipDecorator.decorate_collection(ms)]
    end
  end

  def user_archived_projects
    user_projects_repository.archived_with_memberships.map do |project, ms|
      [project, MembershipDecorator.decorate_collection(ms)]
    end
  end
end

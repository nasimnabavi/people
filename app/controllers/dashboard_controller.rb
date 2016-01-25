class DashboardController < ApplicationController
  include ContextFreeRepos

  expose(:projects_json) do
    ActiveModel::ArraySerializer.new(
      projects.decorate,
      each_serializer: ProjectSerializer
    ).as_json
  end
  expose(:users_json) do
    ActiveModel::ArraySerializer.new(
      users.decorate,
      each_serializer: UserSerializer
    ).as_json
  end
  expose(:projects) { projects_repository.active_with_memberships.order(:name) }
  expose(:users) do
    User.includes(:memberships, :primary_roles)
  end
  expose(:memberships) do
    Membership.where(project_id: projects.ids)
  end
  expose(:memberships_json) do
    memberships.decorate.as_json
  end
  expose(:note)

  before_action :set_time_gon

  def active
    self.projects = projects_repository.active_with_memberships.order(:name)
    render :index
  end

  def potential
    self.projects = projects_repository.potential.order(:name)
    render :index
  end

  def archived
    self.projects = projects_repository.archived.order(:name)
    render :index
  end

  private

  def set_time_gon
    gon.currentTime = Time.now
  end
end

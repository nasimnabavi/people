class DashboardController < ApplicationController
  include ContextFreeRepos

  expose(:projects) do
    ActiveModel::ArraySerializer.new(projects_repository.active_with_memberships.decorate,
      each_serializer: ProjectSerializer).as_json
  end
  expose(:users) do
    ActiveModel::ArraySerializer.new(
      User.includes(:memberships, :primary_roles).where(memberships: { project_id: projects.ids }).decorate,
      each_serializer: UserSerializer
    ).as_json
  end
  expose(:memberships) { Membership.where(project_id: projects.ids).decorate.as_json }
  expose(:note)

  before_action :set_time_gon

  def active
    self.projects = projects_repository.active_with_memberships
    render :index
  end

  def potential
    self.projects = projects_repository.potential
    render :index
  end

  def archived
    self.projects = projects_repository.archived
    render :index
  end

  private

  def set_time_gon
    gon.currentTime = Time.now
  end
end

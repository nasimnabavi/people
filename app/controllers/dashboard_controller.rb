class DashboardController < ApplicationController
  include ContextFreeRepos

  expose_decorated(:projects) { projects_repository.active_with_memberships }
  expose_decorated(:users) do
    User.includes(:memberships, :primary_roles).where(memberships: { project_id: projects.ids })
  end
  expose_decorated(:memberships) { Membership.where(project_id: projects.ids) }
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

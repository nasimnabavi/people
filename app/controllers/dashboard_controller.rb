class DashboardController < ApplicationController
  include ContextFreeRepos

  expose(:projects) { projects_repository.all }
  expose(:roles) { roles_repository.all }
  expose(:primary_positions) { positions_repository.primary }
  expose_decorated(:users) { users_repository.all_by_name }
  expose_decorated(:memberships) { memberships_repository.active_ongoing }

  def index
    gon.rabl template: 'app/views/dashboard/users', as: 'users'
    gon.rabl template: 'app/views/dashboard/memberships', as: 'memberships'
    gon.rabl template: 'app/views/dashboard/roles', as: 'roles'
    gon.rabl template: 'app/views/dashboard/projects', as: 'projects'
    gon.currentTime = Time.now

    if params[:cookie]
      cookies[:note_id] = params[:cookie]
    else
      cookies.delete(:note_id)
    end
  end
end

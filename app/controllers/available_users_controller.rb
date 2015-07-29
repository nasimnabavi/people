class AvailableUsersController < ApplicationController
  include ContextFreeRepos

  before_filter :authenticate_admin!

  expose(:users) do
    AvailableUserDecorator.decorate_collection(available_users_repository.all)
  end
  expose(:juniors_and_interns) do
    AvailableUserDecorator.decorate_collection(available_users_repository.juniors)
  end
  expose(:roles) { roles_repository.all }
  expose(:abilities) { abilities_repository.all }

  def index
    gon.users = Rabl.render(users, 'available_users/index',
      view_path: 'app/views', format: :hash, locals: { cache_key: 'all'} )
    gon.juniors_and_interns = Rabl.render(juniors_and_interns, 'available_users/index',
      view_path: 'app/views', format: :hash, locals: { cache_key: 'juniors_and_interns'})
    gon.roles = roles
    gon.abilities = abilities
  end
end

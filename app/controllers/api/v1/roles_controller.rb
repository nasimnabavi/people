module Api::V1
  class RolesController < Api::ApiController
    expose(:roles) { roles_repository.all }
    expose(:role)
  end
end

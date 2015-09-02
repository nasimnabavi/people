module Api::V2
  class UsersController < Api::ApiController
    expose_decorated(:users) { User.includes(memberships: :project) }

    def index
      render json: users, each_serializer: UserSerializer, root: false
    end
  end
end

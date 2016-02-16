module Api
  module V3
    class UsersController < Api::ApiController
      expose(:technical_users) { ScheduledUsersRepository.new.all }

      def technical
        render json: technical_users, each_serializer: Api::V3::UserWithMembershipsSerializer, root: false
      end
    end
  end
end

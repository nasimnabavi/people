class SchedulingController < ApplicationController
  expose(:users) do
    ActiveModel::ArraySerializer.new(
      ScheduledUsersRepository.new.technical,
      each_serializer: UserSchedulingSerializer
    ).as_json
  end
  expose(:roles) do
    ActiveModel::ArraySerializer.new(
      RolesRepository.new.all_technical,
      each_serializer: RoleSerializer
    ).as_json
  end
  expose(:abilities) do
    ActiveModel::ArraySerializer.new(
      AbilitiesRepository.new.all,
      each_serializer: AbilitySerializer
    ).as_json
  end
end

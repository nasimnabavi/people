class SchedulingController < ApplicationController
  expose(:users) { ActiveModel::ArraySerializer.new(ScheduledUsersRepository.new.technical,
    each_serializer: UserSchedulingSerializer).as_json }
  expose(:roles) { ActiveModel::ArraySerializer.new(RolesRepository.new.all_technical,
    each_serializer: RoleSerializer).as_json }
  expose(:abilities) { ActiveModel::ArraySerializer.new(AbilitiesRepository.new.all,
    each_serializer: AbilitySerializer).as_json }
end

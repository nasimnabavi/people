module CollectionsSerialization
  extend ActiveSupport::Concern

  def serialize_projects(projects_array)
    ActiveModel::ArraySerializer.new(projects_array, each_serializer: Api::V2::ProjectSerializer)
  end

  def serialize_users(users_array)
    ActiveModel::ArraySerializer.new(users_array,
      each_serializer: Api::V2::UserStatisticsSerializer)
  end
end

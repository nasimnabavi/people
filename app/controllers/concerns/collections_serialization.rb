module CollectionsSerialization
  extend ActiveSupport::Concern

  def serialize_projects(projects_array)
    ActiveModel::ArraySerializer.new(projects_array, each_serializer: Api::V2::ProjectSerializer)
  end
end

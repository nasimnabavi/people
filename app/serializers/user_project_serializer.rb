class UserProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :starts_at, :end_at, :archived, :potential, :internal, :project_type,
    :color, :initials
end

attributes :id, :name, :archived, :potential, :end_at, :color, :initials, :internal, :project_type

child :notes do
  extends 'notes/base'
end

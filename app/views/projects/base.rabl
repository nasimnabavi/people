attributes :id, :name, :archived, :potential, :end_at, :colour, :initials, :internal, :project_type

child :notes do
  extends 'notes/base'
end

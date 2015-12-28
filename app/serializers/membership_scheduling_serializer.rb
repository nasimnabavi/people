class MembershipSchedulingSerializer < ActiveModel::Serializer
  attributes :project_id, :ends_at, :starts_at, :billable, :internal, :name

  def internal
    object.project.internal
  end

  def potential
    object.project.potential
  end

  def name
    object.project.name
  end
end

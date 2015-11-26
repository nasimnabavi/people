module Api::V2
  class MembershipSerializer < ActiveModel::Serializer
    attributes :project_name, :starts_at, :ends_at, :role, :project_id

    def project_name
      object.project.name
    end

    def role
      object.role.name
    end
  end
end

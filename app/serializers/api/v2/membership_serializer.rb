module Api::V2
  class MembershipSerializer < ActiveModel::Serializer
    attributes :project_name, :starts_at, :ends_at

    def project_name
      object.project.name
    end
  end
end

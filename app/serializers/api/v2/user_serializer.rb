module Api::V2
  class UserSerializer < ActiveModel::Serializer
    attributes :uid, :email, :first_name, :last_name, :gh_nick, :archived, :primary_roles, :role,
      :primary_roles_names

    has_many :memberships, serializer: MembershipSerializer

    def memberships
      object.memberships.group_by(&:project_id).map { |_key, value| value.last }
    end

    def role
      object.primary_role.try(:name)
    end

    def primary_roles_names
      object.primary_roles.pluck(:name)
    end
  end
end

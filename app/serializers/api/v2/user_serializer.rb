module Api::V2
  class UserSerializer < ActiveModel::Serializer
    attributes :uid, :email, :first_name, :last_name, :gh_nick, :archived, :role

    has_many :memberships, serializer: MembershipSerializer

    def memberships
      object.memberships.group_by(&:project_id).map { |_key, value| value.last }
    end

    def role
      object.primary_role.try(:name)
    end
  end
end

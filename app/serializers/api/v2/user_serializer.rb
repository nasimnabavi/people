module Api::V2
  class UserSerializer < ActiveModel::Serializer
    attributes :uid, :email, :first_name, :last_name, :gh_nick, :archived

    has_many :memberships, serializer: MembershipSerializer

    def memberships
      object.memberships.group_by(&:project_id).map { |_key, value| value.last }
    end
  end
end

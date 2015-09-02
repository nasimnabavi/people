module Api::V2
  class UserSerializer < ActiveModel::Serializer
    attributes :uid, :email, :first_name, :last_name, :gh_nick, :archived

    has_many :memberships, serializer: MembershipSerializer
  end
end

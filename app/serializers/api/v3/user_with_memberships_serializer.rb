module Api
  module V3
    class UserWithMembershipsSerializer < ActiveModel::Serializer
      attributes :primary_role_name, :first_name, :last_name
      has_many :memberships, embed: :objects, serializer: Api::V3::MembershipSerializer

      def primary_role_name
        object.primary_roles[0].try(:name)
      end
    end
  end
end

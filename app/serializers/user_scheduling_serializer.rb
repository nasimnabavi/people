class UserSchedulingSerializer < ActiveModel::Serializer
  attributes :id, :gravatar, :primary_role, :name, :user_notes, :ability_ids
  has_many :current_memberships, embed: :objects, serializer: MembershipSchedulingSerializer
  has_many :next_memberships, embed: :objects, serializer: MembershipSchedulingSerializer
  has_many :booked_memberships, embed: :objects, serializer: MembershipSchedulingSerializer

  def name
    "#{object.last_name} #{object.first_name}"
  end

  def primary_role
    role = object.primary_roles[0]
    { name: role.try(:name), id: role.try(:id) }
  end
end

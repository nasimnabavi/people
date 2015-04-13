class FlatMembershipsBuilder
  attr_accessor :user, :repository

  def initialize(user)
    @user = user
    @repository = UserMembershipsRepository.new(user)
  end

  def build
    grouped_memberships = {}
    repository.all_grouped_by_slug.each do |slug, memberships|
      grouped_memberships[slug] = build_membership_data(memberships)
    end
    grouped_memberships
  end

  private

  def build_membership_data(memberships)
    {
      starts_at: get_minimum_start_at(memberships),
      ends_at: get_maximum_ends_at(memberships),
      role: get_role(memberships)
    }
  end

  def get_minimum_start_at(memberships)
    return nil if memberships.any? { |m| m.starts_at.nil? }
    memberships.map(&:starts_at).compact.min
  end

  def get_maximum_ends_at(memberships)
    return nil if memberships.any? { |m| m.ends_at.nil? }
    memberships.map(&:ends_at).compact.max
  end

  def get_role(memberships)
    memberships.map{ |m| m.role.name }.last
  end
end

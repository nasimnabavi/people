class MembershipCollision
  attr_accessor :membership, :collisions

  def initialize(membership)
    @membership = membership
    @collisions = find_collisions
  end

  def call!
    return if junior_staying_in_current_project?
    return unless collisions.any?

    membership.errors.add(:project, 'user is not available at given time for this project')

    self
  end

  private

  def junior_staying_in_current_project?
    junior_dev? && booking? && collides_only_with_selected_project?
  end

  def junior_dev?
    membership.user.primary_role.try(:name) == 'junior'
  end

  def booking?
    membership.booked
  end

  def collides_only_with_selected_project?
    collisions.reject { |m| m.project == membership.project }.count == 0
  end

  def find_collisions
    if membership.ends_at.present?
      memberships.where(
        '(starts_at <= ? AND ends_at = ?) OR (starts_at <= ? AND ends_at >= ?)',
        membership.ends_at, nil, membership.ends_at, membership.starts_at
      )
    else
      memberships.where(
        'ends_at = ? OR ends_at >= ?',
        nil, membership.starts_at
      )
    end
  end

  def memberships
    Membership.with_user(membership.user)
      .where('id not in (?) and project_id = ?',
        membership.id, membership.project.try(:id))
  end
end

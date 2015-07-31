class AvailableUsersRepository
  def all
    users_with_includes(
      User.where(available: true, archived: false, primary_role: technical_roles_ids))
  end

  def juniors
    users_with_includes(User.where(primary_role: non_billable_technical_roles))
  end

  private

  def users_with_includes(users)
    users.includes(
      :roles,
      :abilities,
      :projects,
      current_memberships: [:project],
      potential_memberships: [:project],
      next_memberships: [:project],
      booked_memberships: [:project],
      last_membership: [:project],
      positions: [:role],
      primary_role: [:users])
  end

  def non_billable_technical_roles
    @non_billable_technical_roles ||= Role.technical.non_billable
  end

  def technical_roles_ids
    @technical_roles_ids ||= Role.where(technical: true).pluck(:id)
  end
end

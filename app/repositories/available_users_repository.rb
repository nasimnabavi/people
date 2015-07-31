class AvailableUsersRepository
  def all
    users_with_includes(
      User.where(available: true, archived: false, primary_role: technical_roles_ids))
  end

  def juniors
    users_with_includes(User.where(primary_role: non_billable_technical_roles))
  end

  def to_rotate
    users_with_includes(
      User.joins(memberships: [:project]).active.where(
        primary_role: billable_technical_roles,
        projects: { end_at: nil, internal: false },
        memberships: { ends_at: nil }
        ).merge(Project.active.nonpotential).order('memberships.starts_at ASC')
      )
  end

  private

  def users_with_includes(users)
    users.includes(
      :roles,
      :abilities,
      :projects,
      :longest_current_membership,
      current_memberships: [:project],
      potential_memberships: [:project],
      next_memberships: [:project],
      booked_memberships: [:project],
      positions: [:role],
      primary_role: [:users])
  end

  def non_billable_technical_roles
    @non_billable_technical_roles ||= Role.technical.non_billable
  end

  def billable_technical_roles
    @billable_technical_roles ||= Role.technical.billable
  end

  def technical_roles_ids
    @technical_roles_ids ||= Role.where(technical: true).pluck(:id)
  end
end

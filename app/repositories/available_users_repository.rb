class AvailableUsersRepository
  def all
    base_users.where(available: true)
  end

  def juniors
    base_users.where(primary_role: non_billable_technical_roles)
  end

  def to_rotate
    not_booked_billable_users.joins(memberships: :project).where(
      projects: { end_at: nil, internal: false },
      memberships: { ends_at: nil }
      ).merge(Project.active.nonpotential).order('memberships.starts_at ASC')
  end

  def in_internals
    not_booked_billable_users.joins(memberships: :project).where(
      projects: { internal: true }
      ).merge(Membership.active.unfinished.started)
  end

  def with_rotations_in_progress
    not_booked_billable_users.joins(memberships: :project)
      .merge(Project.active.unfinished.started)
      .merge(Membership.not_started.active)
  end

  def in_commercial_projects_with_due_date
    not_booked_billable_users.joins(memberships: :project).where(
        projects: { internal: false }
      ).where(
        'memberships.ends_at > :now
        OR projects.end_at > :now',
        { now: Time.current }
      ).merge(Project.active.started).order('COALESCE(memberships.ends_at, projects.end_at)')
  end

  private

  def base_users
    User.active.includes(
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

  def billable_users
    base_users.where(primary_role: billable_technical_roles)
  end

  def not_booked_billable_users
    billable_users.not_booked
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

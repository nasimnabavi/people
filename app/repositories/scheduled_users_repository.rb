class ScheduledUsersRepository
  def juniors_and_interns
    base_users.joins(:positions).available.where(positions: { role: non_billable_technical_roles, primary: true } )
  end

  def to_rotate
    not_booked_billable_users.without_scheduled_commercial_memberships.joins(memberships: :project)
      .where(
        projects: { end_at: nil, internal: false },
        memberships: { ends_at: nil }
      ).merge(Project.active.nonpotential.not_maintenance).order('memberships.starts_at ASC')
  end

  def in_internals
    not_booked_billable_users.without_scheduled_commercial_memberships.joins(memberships: :project)
      .where(
        projects: { internal: true }
      ).merge(Membership.active.unfinished.started)
  end

  def with_rotations_in_progress
    not_booked_billable_users.joins(memberships: :project)
      .merge(Project.active.unfinished.started.commercial.not_maintenance)
      .merge(Membership.not_started.active.not_internal)
  end

  def in_commercial_projects_with_due_date
    not_booked_billable_users.without_scheduled_commercial_memberships
      .joins(current_memberships: [:project])
      .where("(projects.internal = 'f') AND (memberships.ends_at > :now OR projects.end_at > :now)",
        now: 1.day.ago)
      .merge(Project.active.commercial.started.not_maintenance)
      .order('COALESCE(memberships.ends_at, projects.end_at)')
  end

  def booked
    billable_users.booked
  end

  def unavailable
    UnavailableProjectBuilder.new.call
    technical_users.not_booked.unavailable
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

  def technical_users
    base_users.technical
  end

  def billable_users
    base_users.joins(:positions).where(positions: { role: billable_technical_roles, primary: true } )
  end

  def not_booked_billable_users
    billable_users.not_booked.available
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

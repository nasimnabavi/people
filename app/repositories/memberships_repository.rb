class MembershipsRepository
  def all
    Membership.includes(:project, :user, :role).all
  end

  def active_ongoing
    Membership.unfinished.not_archived
  end

  def upcoming_changes(days)
    # FIXME: it should be more friendly
    Membership.includes(:project)
      .where("(memberships.ends_at BETWEEN ? AND ?) OR (memberships.starts_at BETWEEN ? AND ?)",
             Time.now,
             days.days.from_now,
             Time.now,
             days.days.from_now
            )
  end
end

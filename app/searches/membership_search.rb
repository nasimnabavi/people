class MembershipSearch < Searchlight::Search
  search_on Membership.includes(:project, :user, :role)

  searches :user, :archived, :booked, :ends_later_than, :with_end_date, :potential,
    :starts_earlier_than, :starts_later_than, :project_end_time

  def search_user
    search.where(user_id: user.id)
  end

  def search_archived
    search_for_project(archived: archived)
  end

  def search_potential
    search_for_project(potential: potential)
  end

  def search_project_end_time
    search_for_project(end_at: project_end_time)
  end

  def search_ends_later_than
    search.where('memberships.ends_at >= ? or memberships.ends_at IS NULL', ends_later_than)
  end

  def search_starts_earlier_than
    search.where('memberships.starts_at <= ?', starts_earlier_than)
  end

  def search_starts_later_than
    search.where('memberships.starts_at >= ?', starts_later_than)
  end

  def search_booked
    search.where(booked: booked)
  end

  def search_with_end_date
    condition = with_end_date ? 'memberships.ends_at IS NOT NULL' : 'memberships.ends_at IS NULL'
    search.where(condition)
  end

  private

  def search_for_project(params)
    project_ids = ProjectSearch.new(params).results.pluck(:id)
    search.where(project_id: project_ids)
  end
end

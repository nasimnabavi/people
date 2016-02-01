class ProjectSearch < Searchlight::Search
  def base_query
    Project.all
  end

  def search_potential
    Project.where(potential: potential)
  end

  def search_archived
    Project.where(archived: archived)
  end

  def search_memberships
    Project.where(id: memberships.map(&:project_id))
  end

  def search_end_at
    Project.where('end_at >= ? OR end_at = ?', end_at, nil)
  end
end

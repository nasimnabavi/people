class ProjectsRepository
  def all
    @all ||= Project.all.includes(:memberships, :notes).order('lower(name)').all
  end

  def get(id)
    all.find { |p| p.id == id }
  end

  def with_notes
    all
  end

  def active
    Project.where(archived: false, potential: false)
  end

  def active_sorted
    active.sort_by { |project| project.name.downcase }
  end

  def ending_in_a_week
    Project.active.where(end_at: (1.week.from_now - 1.day)..1.week.from_now)
  end

  def find_or_create_by_name(name)
    Project.where(name: name).first_or_create project_type: 'regular'
  end

  def not_potential
    Project.where(potential: false)
  end

  def projects_with_memberships_and_notes
    Project.includes(memberships: [:user], notes: [:user])
  end

  def active_with_memberships
    projects_with_memberships_and_notes.where(archived: false, potential: false)
  end

  def potential
    projects_with_memberships_and_notes.where(potential: true, archived: false)
  end

  def archived
    projects_with_memberships_and_notes.where(archived: true)
  end

  def to_synchronize
    Project.where(potential: false, synchronize: true)
  end
end

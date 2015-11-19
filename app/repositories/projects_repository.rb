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
    all.select { |p| !p.archived }
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

  def to_synchronize
    Project.where(potential: false, synchronize: true)
  end
end

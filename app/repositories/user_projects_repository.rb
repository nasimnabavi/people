class UserProjectsRepository
  attr_accessor :user, :user_memberships_repository, :projects_repository

  def initialize(user, user_memberships_repository, projects_repository)
    self.user = user
    self.user_memberships_repository = user_memberships_repository
    self.projects_repository = projects_repository
  end

  def active_with_memberships
    memberships_by_project.select{ |project, _membership| !project.archived? }
      .sort_by { |_project, memberships| memberships.first.starts_at }
  end

  def archived_with_memberships
    memberships_by_project.select{ |project, _membership| project.archived? }
      .sort_by { |_project, memberships| memberships.first.starts_at }
  end

  def potential
    user_memberships_repository.potential
    self
  end

  def next
    user_memberships_repository.next
    self
  end

  def current
    user_memberships_repository.current
    self
  end

  def items
    memberships = user_memberships_repository.items
    ProjectSearch.new(memberships: memberships).results
  end

  private

  def memberships_by_project
    @memberships_by_project ||= build_memberships_by_project
  end

  def build_memberships_by_project
    # CHECKQUERY: we use membership.role in view
    user_memberships_repository.items.group_by(&:project_id).each_with_object({}) do |data, memo|
      memberships = data[1]
      project = projects_repository.get(data[0])
      memo[project] = memberships
    end
  end
end

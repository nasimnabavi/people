module Trello
  class AddUserToProject
    attr_accessor :user, :project

    def initialize(user_name, project_name)
      self.user = UserRepository.new.find_by_full_name(user_name)
      self.project = ProjectsRepository.new.find_or_create_by_name(project_name)
    end

    def call!
      UserMembershipRepository.new(user).create(
        project: project,
        starts_at: Date.yesterday,
        role: user.primary_role,
        billable: false
      )
    end
  end
end

module Trello
  class AddUserToProject
    attr_accessor :user, :user_memberships_repo, :project

    def initialize(user_name, project_name)
      self.user = UserRepository.new.find_by_full_name(user_name)
      self.project = ProjectsRepository.new.find_or_create_by_name(project_name)
      self.user_memberships_repo = UserMembershipsRepository.new(user)
    end

    def call
      finish_other_active_memberships
      assign_user_to_the_project
    end

    private

    def finish_other_active_memberships
      user_memberships_repo.not_ended.items.each do |membership|
        if membership.project != project
          membership.update ends_at: Date.yesterday
        end
      end
    end

    def assign_user_to_the_project
      user_memberships_repo.create(
        project: project,
        starts_at: Date.yesterday,
        role: user.primary_role,
        billable: false
      )
    end
  end
end

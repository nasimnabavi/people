module Trello
  class AddUserToProject
    attr_accessor :user, :user_name, :user_memberships_repo, :projects, :project_names

    def initialize(user_name, project_names)
      self.user = UserRepository.new.find_by_full_name(user_name)
      self.user_name = user_name
      self.user_memberships_repo = UserMembershipsRepository.new(user)
      self.project_names = project_names
      self.projects = []
    end

    def call
      if user
        finish_other_active_memberships
        find_or_create_projects
        assign_user_to_projects
      else
        logger.info "User #{user_name} does not exist"
      end
    end

    private

    def find_or_create_projects
      project_names.each do |project_name|
        project = ProjectsRepository.new.find_or_create_by_name(project_name)

        if project.valid?
          projects << project
        else
          logger.info "Invalid project name: #{project_name}"
        end
      end
    end

    def logger
      @@logger ||= Logger.new("#{Rails.root}/log/trello.log")
    end

    def finish_other_active_memberships
      user_memberships_repo.not_ended.items.each do |membership|
        unless project_names.include? membership.project.name
          membership.update ends_at: Date.yesterday
        end
      end
    end

    def assign_user_to_projects
      projects.each do |project|
        # TODO: investigate why project presence validation does not work here
        if project.valid?
          user_memberships_repo.create(
            project: project,
            starts_at: Date.yesterday,
            role: user.primary_role,
            billable: false
          )
        end
      end
    end
  end
end

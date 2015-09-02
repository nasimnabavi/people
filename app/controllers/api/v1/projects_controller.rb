module Api::V1
  class ProjectsController < Api::ApiController
    expose(:projects) { projects_repository.not_potential }
    expose(:project)
  end
end

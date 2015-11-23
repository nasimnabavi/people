module Api::V1
  class ProjectsController < Api::ApiController
    expose(:projects) { projects_repository.to_synchronize }
    expose(:project)
  end
end

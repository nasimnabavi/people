module Trello
  class ArchiveProjectsJob
    include SuckerPunch::Job

    def perform(labels)
      ArchiveProjects.new(labels).call
    end
  end
end

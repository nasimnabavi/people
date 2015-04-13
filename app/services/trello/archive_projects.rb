module Trello
  class ArchiveProjects
    attr_accessor :labels

    def initialize(labels)
      self.labels = labels
    end

    def call
      Project.where.not(name: labels).each do |project|
        project.archived = true
        project.save
      end
    end
  end
end

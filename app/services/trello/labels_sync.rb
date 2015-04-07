module Trello
  class LabelsSync
    attr_accessor :labels

    def initialize(labels)
      self.labels = labels
    end

    def call!
      labels.each do |label|
        CreateProjectFromLabel.new(label).call!
      end

      ArchiveProjects.new(labels).call!
    end
  end
end

module Trello
  class LabelsSync
    attr_accessor :labels

    def initialize(labels)
      self.labels = labels
    end

    def call
      labels.each do |label|
        CreateProjectFromLabelJob.new.perform(label)
      end

      ArchiveProjectsJob.new.perform(labels)
    end
  end
end

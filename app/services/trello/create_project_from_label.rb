module Trello
  class CreateProjectFromLabel
    attr_accessor :label

    def initialize(label)
      self.label = label
    end

    def call!
      ProjectsRepository.new.find_or_create_by_name label
    end
  end
end

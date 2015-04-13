module Trello
  class CreateProjectFromLabelJob
    include SuckerPunch::Job

    def perform(label)
      CreateProjectFromLabel.new(label).call
    end
  end
end

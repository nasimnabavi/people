module Trello
  class CardSync
    attr_accessor :labels, :user_name

    def initialize(card)
      self.labels = card.card_labels
      self.user_name = card.name
    end

    def call!
      if labels.any?
        AddUserToProject.new(user_name, labels.first['name']).call!
      else
        RemoveUserFromProjects.new(user_name).call!
      end
    end
  end
end

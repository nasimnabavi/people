module Trello
  class CardSync
    attr_accessor :labels, :user_name

    def initialize(card)
      self.labels = card.card_labels.reject { |l| l['name'].empty? }
      self.user_name = card.name
    end

    def call
      if labels.any?
        AddUserToProject.new(user_name, labels.map{ |l| l['name'] }).call
      else
        RemoveUserFromProjects.new(user_name).call
      end
    end
  end
end

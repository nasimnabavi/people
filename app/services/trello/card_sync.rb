module Trello
  class CardSync
    attr_accessor :labels, :user_name

    def initialize(card)
      self.labels = card.card_labels.reject { |l| l['name'].empty? }
      self.user_name = card.name
    end

    def call
      if labels.any?
        labels.each do |label|
          AddUserToProject.new(user_name, label['name']).call
        end
      else
        RemoveUserFromProjects.new(user_name).call
      end
    end
  end
end

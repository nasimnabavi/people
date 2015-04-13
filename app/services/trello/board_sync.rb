module Trello
  class BoardSync
    attr_accessor :board, :cards, :labels

    def initialize(board)
      self.board = board
      fetch_cards
      fetch_labels
    end

    def call
      sync_cards
      sync_labels
    end

    private

    def fetch_cards
      self.cards = board.cards
    end

    def fetch_labels
      self.labels = board.labels(false).map do |label|
        label.name unless label.name.empty?
      end.compact
    end

    def sync_cards
      cards.each do |card|
        CardSyncJob.new.perform(card)
      end
    end

    def sync_labels
      LabelsSync.new(labels).call
    end
  end
end

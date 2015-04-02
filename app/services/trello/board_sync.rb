module Trello
  class BoardSync
    attr_accessor :board, :cards

    def initialize(board)
      self.board = board
      fetch_cards
    end

    def call!
      cards.each do |card|
        CardSync.new(card).call!
      end
    end

    private

    def fetch_cards
      self.cards = board.cards
    end
  end
end

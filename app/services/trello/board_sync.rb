module Trello
  class BoardSync
    attr_accessor :board, :cards

    def initialize(board)
      self.board = board
      fetch_cards
    end

    private

    def fetch_cards
      self.cards = board.cards
    end
  end
end

module Trello
  class ProjectChecker
    attr_accessor :board, :cards

    def initialize(board)
      self.board = board
      fetch_cards
    end

    private

    def fetch_cards
      @cards = board.cards
    end
  end
end

module Trello
  class ProjectChecker
    attr_accessor :board, :cards, :user_membership_repo

    def initialize(board, user_membership_repo = UserMembershipRepository)
      self.board = board
      self.user_membership_repo = user_membership_repo
      get_cards
    end

    private

    def get_cards
      @cards = board.cards
    end

    def user_from_card(card)
      attrs = {
        first_name: card.name.split[0],
        last_name:  card.name.split[1]
      }
      UserRepository.new.find_by(attrs)
    end
  end
end

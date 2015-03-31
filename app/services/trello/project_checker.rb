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
      UserRepository.new.find_by_full_name(card.name)
    end
  end
end

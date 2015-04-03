module Trello
  class RemoveUserFromProjects
    attr_accessor :user

    def initialize(user_name)
      self.user = UserRepository.new.find_by_full_name(user_name)
    end

    def call!
      UserMembershipRepository.new(user).end_memberships(Date.yesterday)
    end
  end
end

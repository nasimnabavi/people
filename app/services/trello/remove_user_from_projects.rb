module Trello
  class RemoveUserFromProjects
    attr_accessor :user

    def initialize(user_name)
      self.user = UserRepository.new.find_by_full_name(user_name)
    end

    def call
      return unless user.present?
      UserMembershipsRepository.new(user).current.items.each do |membership|
        membership.ends_at = Date.yesterday
        membership.save
      end
    end
  end
end

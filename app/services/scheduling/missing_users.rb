module Scheduling
  class MissingUsers
    def initialize(user_ids)
      @user_ids = user_ids
    end
    def call
      User.technical.active.where.not(id: @user_ids)
    end
  end
end

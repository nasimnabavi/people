module Sql
  class AdminRole < ActiveRecord::Base
    has_many :users

  end
end

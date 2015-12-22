module Relations
  module Sql
    class Users < ROM::Relation[:sql]
      register_as :users
      dataset :users
    end
  end
end

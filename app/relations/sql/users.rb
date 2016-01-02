module Relations
  module Sql
    class Users < ROM::Relation[:sql]
      dataset :users
    end
  end
end

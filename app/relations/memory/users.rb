module Relations
  module Memory
    class Users < ROM::Relation[:memory]
      register_as :users
      dataset :users
    end
  end
end

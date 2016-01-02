module Relations
  module Memory
    class Users < ROM::Relation[:memory]
      include Relations::Memory::BaseView

      dataset :users
    end
  end
end

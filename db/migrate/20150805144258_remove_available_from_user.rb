class RemoveAvailableFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :available
  end

  def down
    add_column :users, :available, :boolean, default: true
  end
end

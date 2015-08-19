class RemoveAvailableSinceFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :available_since
  end

  def down
    add_column :users, :available_since, :date
  end
end

class ChangeAvailableSinceColumnToDate < ActiveRecord::Migration
  def change
    change_column :users, :available_since, :date
  end
end

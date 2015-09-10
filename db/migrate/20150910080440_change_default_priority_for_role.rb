class ChangeDefaultPriorityForRole < ActiveRecord::Migration
  def change
    change_column_default :roles, :priority, 1
  end
end

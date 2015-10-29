class AddMaintenanceSinceToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :maintenance_since, :datetime
  end
end

class FixColorNameForProjects < ActiveRecord::Migration
  def change
    rename_column :projects, :colour, :color
  end
end

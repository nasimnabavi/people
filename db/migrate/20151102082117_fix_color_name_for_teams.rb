class FixColorNameForTeams < ActiveRecord::Migration
  def change
    rename_column :teams, :colour, :color
  end
end

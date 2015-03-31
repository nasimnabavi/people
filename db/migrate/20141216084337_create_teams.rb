class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :initials
      t.string :colour
      t.timestamps
    end
  end
end

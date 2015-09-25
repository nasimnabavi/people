class AddStartsAtToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :starts_at, :datetime
  end
end

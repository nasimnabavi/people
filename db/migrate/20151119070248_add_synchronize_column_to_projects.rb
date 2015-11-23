class AddSynchronizeColumnToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :synchronize, :boolean, null: false, default: true
  end
end

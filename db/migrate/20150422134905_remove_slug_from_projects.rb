class RemoveSlugFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :slug, :string
  end
end

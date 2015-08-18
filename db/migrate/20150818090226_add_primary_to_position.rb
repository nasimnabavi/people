class AddPrimaryToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :primary, :boolean, default: false, null: false
  end
end

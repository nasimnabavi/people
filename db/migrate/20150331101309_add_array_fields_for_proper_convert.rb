class AddArrayFieldsForProperConvert < ActiveRecord::Migration
  def change
    add_column :roles, :user_ids, :integer, array:true, default: []
    add_column :users, :role_ids, :integer, array:true, default: []
  end
end

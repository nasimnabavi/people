class ChangeAdminRoleToUserAdmin < ActiveRecord::Migration
  class AdminRole < ActiveRecord::Base
    has_many :users
  end

  class User < ActiveRecord::Base
    belongs_to :admin_role
  end

  def up
    add_column :users, :admin, :boolean, default: false

    AdminRole.find_each do |admin_role|
      admin_role.users.update_all(admin: true)
    end

    remove_column :users, :admin_role_id
    drop_table :admin_roles
  end

  def down
    create_table :admin_roles do |t|
      t.timestamps
    end

    add_column :users, :admin_role_id, :integer
    add_index :users, :admin_role_id

    admin_role = AdminRole.create!
    admin_users = User.where(admin: true)
    admin_users.update_all(admin_role_id: admin_role.id)

    remove_column :users, :admin
  end
end

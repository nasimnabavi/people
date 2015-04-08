class ChangeMembershipStartAndEndDateColumnsToDate < ActiveRecord::Migration
  def change
    change_column :memberships, :starts_at, :date
    change_column :memberships, :ends_at, :date
  end
end

class AddBookedAtToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :booked_at, :datetime
  end
end

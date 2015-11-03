class ChangeBelongsToTeamToHasManyTeams < ActiveRecord::Migration
  def up
    create_join_table :users, :teams do |t|
      t.index :user_id
      t.index :team_id
    end

    User.class_eval do
      belongs_to :old_team,
                 class_name: "Team",
                 foreign_key: "team_id"
    end

    User.all.each do |user|
      next if user.old_team.nil?
      user.teams << user.old_team
      user.save
    end

    remove_column :users, :team_id
  end

  def down
    # If we will have one user with many teams it would be nearly impossible to define which
    # team we should migrate back so we will just fail here
    fail ActiveRecord::IrreversibleMigration
  end
end

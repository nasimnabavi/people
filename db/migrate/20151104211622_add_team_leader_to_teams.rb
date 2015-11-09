class AddTeamLeaderToTeams < ActiveRecord::Migration
  def up
    add_reference :teams, :user, index: true

    User.where.not(leader_team_id: nil).each do |user|
      Team.find(user.leader_team_id).update(user_id: user.id)
    end

    remove_column :users, :leader_team_id
  end

  def down
    add_column :users, :leader_team_id, :integer

    Team.where.not(user_id: nil).each do |team|
      User.find(team.user_id).update(leader_team_id: team.id)
    end

    remove_column :teams, :user_id
  end
end

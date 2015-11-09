collection decorated_users
attributes :id, :first_name, :last_name, :name, :email, :leader_team_id, :archived, :team_join_time
node(:gravatar) { |user| user.gravatar_url(:circle) }
node(:info) { |user| user.info }
node(:team_ids) { |user| user.teams.empty? ? nil : user.team_ids }
node(:primary_role_ids) do |user|
  user_primary_positions = primary_positions.select { |p| p.user_id == user.id }
  user_primary_positions.empty? ? [] : user_primary_positions.map(&:role_id)
end

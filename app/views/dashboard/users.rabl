collection decorated_users
attributes :id, :first_name, :last_name, :name, :email, :team_id, :leader_team_id, :archived, :team_join_time
node(:gravatar) { |user| user.gravatar_url(:circle) }
node(:info) { |user| user.info }
node(:primary_role_ids) do |user|
  user_primary_positions = primary_positions.select { |p| p.user_id == user.id }
  user_primary_positions.empty? ? [] : user_primary_positions.map(&:role_id)
end

attributes :id
node(:name) { |user| "#{user.last_name} #{user.first_name}" }
node(:url) { |user| user_path(user) }

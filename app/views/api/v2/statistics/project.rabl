attributes :id, :name
node(:url) { |project| project_path(project) }

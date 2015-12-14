set :branch, 'master'
server ENV['STAGING_SERVER'], user: ENV['STAGING_USER'], roles: %w{web app db}

set :docker_volumes, [
  "#{shared_path}/config/sec_config.yml:/var/www/app/config/sec_config.yml",
  "#{shared_path}/log:/var/www/app/log",
  "#{shared_path}/public/uploads:/var/www/app/public/uploads",
  "people_staging_assets:/var/www/app/public/assets",
  "people_staging_node_modules:/var/www/app/node_modules",
  "#{shared_path}/assets/javascripts/react_bundle.js:/var/www/app/app/assets/javascripts/react_bundle.js",
]

set :docker_links, %w(postgres_ambassador:postgres)
set :docker_additional_options, -> { "--env-file #{shared_path}/.env" }
set :docker_apparmor_profile, "docker-ptrace"
set :docker_dockerfile, "docker/staging/Dockerfile"

namespace :docker do
  namespace :npm do
    task :build do
      on roles(fetch(:docker_role)) do
        execute :docker, task_command("npm run build")
      end
    end
  end
end

after "docker:npm:install", "docker:npm:build"

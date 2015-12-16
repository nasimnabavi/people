lock '3.4.0'

set :application, "people"
set :repo_url,  "git://github.com/netguru/people.git"
set :deploy_to, ENV['DEPLOY_PATH']

set :docker_links, %w(postgres_ambassador:postgres)
set :docker_additional_options, -> { "--env-file #{shared_path}/.env" }
set :docker_apparmor_profile, "docker-ptrace"

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

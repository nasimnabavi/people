lock '3.4.0'

set :application, "people"
set :repo_url,  "git://github.com/netguru/people.git"
set :deploy_to, ENV['DEPLOY_PATH']

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

set :linked_files, %w(config/mongoid.yml config/sec_config.yml config/database.yml)
set :linked_dirs, %w(bin log tmp vendor/bundle public/uploads node_modules)

namespace :webpack do
  task :build do
    on roles :web do
      within release_path do
        execute :bundle, 'exec npm run build'
      end
    end
  end
end

after 'npm:install', 'webpack:build'

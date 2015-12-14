require 'net/ssh/proxy/command'
server ENV['PRODUCTION_SERVER'], user: ENV['PRODUCTION_USER'], roles: %w{web app db}
set :ssh_options, proxy: Net::SSH::Proxy::Command.new("ssh #{ENV['GATEWAY']} -W %h:%p")
set :branch, 'production'

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

set :linked_files, %w(config/mongoid.yml config/sec_config.yml config/database.yml)
set :linked_dirs, %w(log tmp vendor/bundle public/uploads node_modules)
set :npm_flags, '--production --no-spin'

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

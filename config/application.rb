require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_record/railtie"
require "sprockets/railtie"

require File.expand_path('../preinitializer', __FILE__)
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
if defined?(Bundler)
  Bundler.require(:default, Rails.env)
end

module Hrguru
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/app)
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Warsaw'
    config.generators do |g|
      g.orm :active_record
    end
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.hamlcoffee.name_filter = lambda { |n| n.sub /^backbone\/templates\//, '' }
    config.action_dispatch.tld_length = AppConfig.tld_length

    config.to_prepare do
      Rails.application.config.rom_container = ROM::ContainersFactory.new(
        default: ROM::PostgreSqlGatewaysFactory.build_from_active_record_config(
          ActiveRecord::Base.configurations.fetch(Rails.env)
        )
      ).build
    end

  end
end

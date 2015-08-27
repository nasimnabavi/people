if ENV['CI']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'spork'
require 'webmock/rspec'
require 'sucker_punch/testing/inline'
require 'capybara/rspec'
require 'rack_session_access/capybara'
require 'capybara/poltergeist'
require 'phantomjs'
require 'database_cleaner'

Spork.prefork do

  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'shoulda/matchers'

  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  RSpec.configure do |config|
    I18n.enforce_available_locales = false
    WebMock.disable_net_connect!(allow_localhost: true,
                                 allow: [/rest/, /codeclimate.com/])

    config.include FactoryGirl::Syntax::Methods
    config.include Devise::TestHelpers, type: :controller
    config.include Helpers::JSONResponse, type: :controller
    config.include Capybara::DSL

    config.use_transactional_fixtures = false
    config.infer_base_class_for_anonymous_controllers = false

    config.before(:suite) do
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.strategy = :transaction
    end

    config.before(:each, js: true) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each, job: true) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      Timecop.return
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end

  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

  Capybara.register_driver :poltergeist do |app|
    options = {
      phantomjs: Phantomjs.path,
      js_errors: false,
      timeout: 120,
      debug: false,
      phantomjs_options: ['--load-images=no', '--disk-cache=false'],
      inspector: false
    }
    Capybara::Poltergeist::Driver.new(app, options)
  end

  Capybara.javascript_driver = :poltergeist
end

Spork.each_run do
  FactoryGirl.reload
end

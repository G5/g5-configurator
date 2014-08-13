require 'rubygems'
require 'spork'
require 'helpers'

Spork.prefork do
  unless ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
    require "codeclimate-test-reporter"
    CodeClimate::TestReporter.start
  end

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  RSpec.configure do |config|
    config.include Helpers
    config.include Devise::TestHelpers, type: :controller
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false
    config.order = "random"

    config.before :each do
      # create client app creator
      RemoteApp.skip_callback(:create, :after, :create_instruction)
      RemoteApp.create!(kind: CLIENT_APP_CREATOR_KIND)
      RemoteApp.create!(kind: CLIENT_APP_CREATOR_DEPLOYER_KIND)
      RemoteApp.set_callback(:create, :after, :create_instruction)
    end
  end

  Spork.trap_method(Rails::Application, :eager_load!)
  require File.expand_path("../../config/environment", __FILE__)
end

Spork.each_run do
  if ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
    require "codeclimate-test-reporter"
    CodeClimate::TestReporter.start
  end
end

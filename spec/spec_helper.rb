require 'simplecov'
SimpleCov.start 'rails'

require 'rubygems'
require 'spork'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Spork.prefork do
  RSpec.configure do |config|
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false
    config.order = "random"
    config.before(:each) do 
      RemoteApp.delete_all
      Instruction.delete_all
      RemoteApp.skip_callback(:create, :after, :create_instruction)
      RemoteApp.create(name: "g5-client-app-creator", git_repo: "git@git")
      RemoteApp.set_callback(:create, :after, :create_instruction)
    end
  end
  Spork.trap_method(Rails::Application, :eager_load!)
  require File.expand_path("../../config/environment", __FILE__)
  Rails.application.railties.all { |r| r.eager_load! }
end

Spork.each_run do
end

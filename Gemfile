source 'https://rubygems.org'
ruby   '2.1.5'

gem 'rails', '~> 4.1.11'
gem 'jquery-rails'

gem 'quiet_assets', '~> 1.0.1'
gem 'bootstrap-sass', '~> 2.1.0.1'

gem 'webhook'
gem 'g5_authenticatable'

gem 'heroku_resque_autoscaler', '~> 0.1.0'
gem 'microformats2', '2.0.1'

gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.0.3'
gem 'httparty'
gem 'g5_heroku_app_name_formatter'

group :development, :test do
  gem 'resque_spec'
  gem 'dotenv-rails', '~> 0.11.1'
  gem 'sqlite3'
  gem 'rspec-rails', '~> 2.14.1'
  gem 'guard-rspec', require: false
  gem 'rb-fsevent', '~> 0.9.2'
  gem 'foreman'
  gem 'pry'
end

group :test do
  gem 'codeclimate-test-reporter', require: false
  gem 'simplecov', '~> 0.8.2', require: false
  gem 'capybara', '~> 2.2.1'
  gem 'factory_girl_rails'
  gem 'webmock', require: 'webmock/rspec'
  gem 'fabrication'
end

group :production do
  gem 'unicorn'
  gem 'pg'
  gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'honeybadger'
  gem 'lograge'
end

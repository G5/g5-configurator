source "https://rubygems.org"
ruby   "2.1.1"

gem "rails", "4.1.4"
gem "jquery-rails"

gem "quiet_assets", "~> 1.0.1"
gem "bootstrap-sass", "~> 2.1.0.1"

gem "webhook"
gem "g5_authenticatable"

gem "heroku_resque_autoscaler", "~> 0.1.0"
gem "microformats2", "2.0.1"

gem "sass-rails",   "~> 4.0.0"
gem "coffee-rails", "~> 4.0.0"
gem "uglifier", ">= 1.0.3"

group :development, :test do
  gem "dotenv-rails", "~> 0.10.0"
  gem "sqlite3"
  gem "simplecov", "~> 0.8.2", require: false
  gem "rspec-rails", "~> 2.14.1"
  gem "guard-rspec", "~> 4.2.8"
  gem "guard-spork"
  gem "spork"
  gem "rb-fsevent", "~> 0.9.2"
  gem "capybara", "~> 2.2.1"
  gem "foreman"
end

gem "codeclimate-test-reporter", group: :test, require: nil
gem "factory_girl_rails", group: :test

group :production do
  gem "unicorn"
  gem "pg"
  gem "rails_12factor"
  gem "newrelic_rpm"
  gem "honeybadger"
  gem "lograge"
end

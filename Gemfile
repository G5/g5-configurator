source :rubygems
source "https://gems.gemfury.com/***REMOVED***/"

gem "rails", "3.2.11"
gem "pg"
gem "jquery-rails"

gem "rails-default-database", "~> 1.0.6"
gem "quiet_assets", "~> 1.0.1"
gem "bootstrap-sass", "~> 2.1.0.1"

gem "webhook", git: "git://github.com/G5/webhook.git", branch: "configuration"

gem "foreman", "~> 0.60.2"
gem "heroku_resque_autoscaler", "~> 0.1.0"
gem "g5_hentry_consumer", "~> 0.5.0"

group :assets do
  gem "sass-rails",   "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"
  gem "uglifier", ">= 1.0.3"
end

group :development, :test do
  gem "rspec-rails"
  gem "guard-rspec"
  gem "guard-spork"
  gem "spork"
  gem "rb-fsevent", "~> 0.9.1"
  gem "debugger", "~> 1.2.2"
end

group :production do
  gem "thin", "~> 1.5.0"
end

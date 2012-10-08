source :rubygems

gem "rails", "3.2.7"
gem "pg"
gem "jquery-rails"
gem "hentry_consumer", "~> 0.1.2"
gem "heroku-api"
gem "git"
gem 'resque', "~> 1.22.0"
gem 'typhoeus'

group :assets do
  gem "sass-rails",   "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"
  gem "uglifier", ">= 1.0.3"
end

group :development, :test do
  gem "nifty-generators", "~> 0.4.6"
  gem "heroku", "~> 2.32.6"
  gem "rspec-rails"
  gem "guard-rspec"
  gem "guard-spork"
  gem 'spork'
  gem 'rb-fsevent', '~> 0.9.1'
end

group :production do
  gem "thin", "~> 1.5.0"
end

gem "mocha", :group => :test
source :rubygems
source "https://gems.gemfury.com/88yeKzEGfizstwBaXVqj/"

gem "rails", "3.2.7"
gem "pg"
gem "jquery-rails"

gem "quiet_assets", "~> 1.0.1"
gem "bootstrap-sass", "~> 2.1.0.1"

gem "hentry_consumer", path: "/Users/jlsuttles/Dropbox/Projects/g5/hentry_consumer"
gem "g5_hentry_consumer", path: "/Users/jlsuttles/Dropbox/Projects/g5/g5_hentry_consumer"

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
end

group :production do
  gem "thin", "~> 1.5.0"
end

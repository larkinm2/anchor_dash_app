source 'https://rubygems.org'

ruby '2.1.2'

gem 'sinatra', '1.4.5', require: 'sinatra/base'
gem 'redis',  '3.1.0'
gem 'httparty'
gem 'twitter'
gem 'yahoo-finance'
gem 'ffaker'

# only used in development locally
group :development do
  gem 'shotgun'
  gem 'sinatra-contrib', require: 'sinatra/reloader'
end

group :production do
  # gems specific just in the production environment
end

group :test do
  gem 'rspec'
  gem 'capybara', '~> 2.4.1'
end

# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.5'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'devise', '~> 4.8.1'
gem 'draper', '~> 4.0', '>= 4.0.2'
gem 'fastercsv'
gem 'font-awesome-sass', '~> 5.12.0'
gem 'graphql' # rails generate graphql:install
gem 'image_processing', '~> 1.2'
gem 'invisible_captcha', '~> 2.0'
gem 'jquery-rails'
gem 'omniauth-google-oauth2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'rollbar'
gem 'sass-rails', '~> 5.0'
gem 'select2-rails'
gem 'sidekiq', '~> 7.0', '>= 7.0.2'
gem 'sidekiq-failures', '~> 1.0'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'
gem 'whenever'
gem 'wicked_pdf'
gem 'will_paginate', '~> 3.1.0'
gem 'wkhtmltopdf-binary'

gem 'ruby-openai', '~> 5.1'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', require: 'dotenv/rails-now' # .env file
  gem 'letter_opener'

  gem 'pry-byebug', '~> 3.8'
  gem 'pry-rails', '~> 0.3.9'
  gem 'pry-remote', '~> 0.1.8'

  gem 'bullet'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 2.17'
  gem 'pry'

  gem 'rails-controller-testing', '~> 1.0.5'
  gem 'rspec', '~> 3.12'
  gem 'rspec-rails', '~> 6.0', '>= 6.0.3'
  gem 'shoulda-matchers', '~> 5.3'

  gem 'brakeman'

  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'annotate', '~> 3.0', '>= 3.0.3'
  gem 'graphiql-rails'
  gem 'rusky'
  gem 'web-console'
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'rspec-sidekiq', '~> 3.1'
  gem 'selenium-webdriver'
  gem 'simplecov', '~> 0.21.2'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'graphiql-rails', group: :development
# gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

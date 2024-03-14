source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Use Devise for user authentication
gem 'devise', '~> 4.2'

# Use Bootstrap-Sass and Autoprefixer-rails for adding Bootstrap framework
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.6'
gem 'autoprefixer-rails', '~> 6.3', '>= 6.3.7'

# ActiveRecord connection adapter for PostGIS
gem 'activerecord-postgis-adapter', '~> 5.0', '>= 5.0.2'

# Carrierwve for uploading images and processing them
gem 'carrierwave', '~> 1.2', '>= 1.2.1'
gem 'mini_magick', '~> 4.5', '>= 4.5.1'
gem 'fog', '~> 1.38'

gem 'font-awesome-sass'
gem 'frontend-generators', '~> 0.1.1'
gem 'kaminari', '~> 0.17.0'

gem 'sidekiq', '~> 4.2', '>= 4.2.7'

gem 'highline'

gem 'whenever', :require => false

gem 'pundit', '~> 1.1'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano', '~> 3.6', '>= 3.6.1', require: false
  gem 'capistrano-bundler', '~> 1.2', require: false
  gem 'capistrano-rails', '~> 1.1', '>= 1.1.8', require: false

  gem 'capistrano-rbenv', '~> 2.0', '>= 2.0.4', require: false
  gem 'capistrano3-puma', '~> 1.2', '>= 1.2.1', require: false

  gem 'brakeman', :require => false
end

group :test do
  gem 'minitest-rails', '~> 3.0'
  gem 'capybara', '~> 2.7', '>= 2.7.1'
  gem 'poltergeist', '~> 1.10'
  gem 'minitest-rails-capybara', '~> 3.0'
  gem 'selenium-webdriver', '~> 2.53', '>= 2.53.4'
  gem 'chromedriver-helper', '~> 1.0'
  gem 'simplecov', '~> 0.12.0', require: false
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

gem 'dotenv-rails', '~> 2.1', '>= 2.1.1', groups: [:development, :test, :production]

ruby "2.3.1"

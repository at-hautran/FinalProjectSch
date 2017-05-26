source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'

gem 'pg'
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
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

gem "slim-rails"

gem 'bootstrap-sass', '~> 3.3.6'

gem 'pry'

gem 'pry-rails'

gem 'kaminari'

gem 'carrierwave', '~> 1.0'

gem 'mini_magick'

gem 'whenever', :require => false

gem "audited", "~> 4.4"

gem 'gon'

gem 'rabl-rails'

gem 'bcrypt'

gem "simple_calendar", "~> 2.0"

gem 'aasm'

gem 'bootstrap-timepicker-rails'

gem 'jquery-timepicker-addon-rails'

gem 'ffaker'

gem 'bootstrap-form-helpers-rails', :git => 'https://github.com/johnu/bootstrap-form-helpers-rails.git'

gem 'carmen-rails', '~> 1.0.0'
gem 'countries', :require => 'countries/global'
gem 'prawn', '~> 0.8.4'
# gem 'prawn-table'
gem 'invoicing'

gem 'invoice_printer'

gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'
gem 'paypal-recurring'
gem 'activemerchant'
gem 'paypal-sdk-merchant'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'sqlite3'
  gem 'byebug', platform: :mri
end

group :development do
  gem 'sqlite3'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

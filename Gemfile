source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Include web-console gem for Rails 4.2.5.1
group :development do
	gem 'web-console', '~> 2.0'
end 

# Include rails-html-sanitizer for Rails 4.2.5 and aboved version
gem 'rails-html-sanitizer' 

# Include responders for Rails 4.2.5.1 and aboved version
gem 'responders', '~> 2.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
#gem 'jquery-migrate-rails' # Used by slick plugin of jquery for sliding bulletin board
gem 'jquery-turbolinks' # Used by slick plugin of jquery for sliding bulletin board
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
group :development do 
	gem 'capistrano' 
	gem 'capistrano-bundler'
	gem 'capistrano-passenger', '>= 0.1.1'
	gem 'capistrano-rails'
	gem 'capistrano-rvm'
	gem 'highline'
end

# Use debugger
# gem 'debugger', group: [:development, :test]

# Use byebug in rails 5
group :development, :test do
	gem 'byebug'
end

gem 'grape', '~> 0.10'
# Print routes of grape apis via command: rake routes 
gem 'grape-rails-routes' # Load routes that grape provides.
gem 'grape-kaminari' # for api inqueries pagination
gem 'grape-swagger' # for api documents generation
gem 'hashie-forbidden_attributes' # Use with grape gem because it will let grape use its checking parameters procedure instead of rails.

gem 'pg' # For activerecord using postgres
#gem 'pg_search' # For search. 20160325: I don't need it because I don't use full text search in postgres.
gem 'rspec-rails' # Testing rails
gem 'doorkeeper' # OAuth provider
gem 'devise' # User management
gem 'recaptcha', require: "recaptcha/rails" # validate whether user is a robot or not when it try to sign up
gem 'dotenv-rails', :groups => [:development, :test] # load values of ENV. We only use it with recaptcha gem in development and test environment.

gem 'kaminari' # for web pages pagination
gem 'wine_bouncer', '~> 0.5.1' # A Ruby gem that allows Oauth2 protection with Doorkeeper for Grape Api's


#gem 'd3js-rails' # For present data-visualization
gem 'd3-rails' # For present data-visualization
gem 'c3-rails' # For simplifying data-visualization of d3js
gem 'gon' # For passing data from rails to javascript



# gem rails-controller-testing 
# from guide of upgradeing rails 4.2 to rails 5.0: Extraction of some helper methods to rails-controller-testing
gem 'rails-controller-testing'

# gem activemodel-serializers-xml
# from guide of upgradeing rails 4.2 to rails 5.0: XML Serialization
gem 'activemodel-serializers-xml'


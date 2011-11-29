source 'http://rubygems.org'

gem 'rails', '3.1.0'

gem 'sqlite3', '1.3.4'

group :production do
  # gems for Heroku
  gem "pg"
end

group :development do
  gem 'rspec-rails', '2.6.1'
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
end



# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
	gem 'factory_girl_rails', '1.0'
	gem 'rspec-rails', '2.6.1'
	gem 'webrat', '0.7.1'
	gem 'spork', '0.9.0.rc5'
  # Pretty printed test output
  # gem 'turn', :require => false
end


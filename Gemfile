source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '~> 4.1'

gem 'airbrake'
gem 'andand'
gem 'dalli'
gem 'domainatrix'
gem 'haml-rails'
gem 'harvested', :git => 'git://github.com/tpalmer/harvested.git'
gem 'jquery-rails'
gem 'newrelic_rpm'
gem 'omniauth-harvest'
gem 'rails_config'
gem 'rake'
gem 'rspec'
gem 'rspec-rails'
gem 'sass-rails'
gem 'unicorn'

gem 'compass-rails'
gem 'bourbon'
gem 'coffee-rails'
gem 'uglifier'

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'debugger', '~> 1.6'
  gem 'foreman'
  gem 'sqlite3'

  group :guard do
    gem 'guard-cucumber'
    gem 'guard-rspec'
    gem 'guard-annotate'

    group :darwin do
      gem 'growl'
      gem 'rb-fsevent'
    end
  end
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'fakeweb'
  #gem 'fabricator'
  gem 'fuubar'
  gem 'simplecov'
  #gem 'timecop'
  gem 'turnip'
  gem 'vcr', '~> 2.9.0' # 3 will remove fakeweb support
end

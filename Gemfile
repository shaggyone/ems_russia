source "http://rubygems.org"

# Specify your gem's dependencies in robokassa.gemspec
gemspec

gem 'nokogiri'

group :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'ZenTest'
  gem 'rspec'
  gem 'rspec-rails', '>= 2.5.0'
  gem 'factory_girl', '>= 1.3.3'
  gem 'spork', '~> 0.9.0.rc'
  gem 'webrat','0.7.1'
  gem 'factory_girl_rails', '>= 1.0.1'
  gem 'rcov'
  gem 'shoulda'
  gem 'faker'
  gem 'rails', '>= 3.0.7'

#  gem 'celerity'
#  gem 'culerity'
  if RUBY_VERSION < "1.9"
    gem "ruby-debug"
  else
    gem "ruby-debug19"
  end
end

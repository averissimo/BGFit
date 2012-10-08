source 'http://rubygems.org'


gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

gem 'paper_trail'

gem 'blankslate' # required by table_helper
gem 'hirb'
gem 'fancy_irb'
gem 'wirb'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
# !!!!!!!
# changed in order to allow js.coffee views being rendered in production mode
end  
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
#end
# !!!!!!

gem 'jquery-rails'

gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'
gem 'jquery-ui-rails'

gem 'delayed_job_active_record'
gem 'delayed_job_web'
gem 'daemons'

gem 'formtastic'
# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
#gem 'ruby-debug19', :require => 'ruby-debug'
gem 'debugger', group: ['development','test']
group :test do
  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false
end


gem 'devise'
gem 'cancan', github: 'ryanb/cancan', branch: '2.0'
gem 'simple-navigation', github: 'andi/simple-navigation'
gem 'table_helper', github: 'rchekaluk/table_helper'

gem 'strong_parameters'

#gem 'will_paginate', '~> 3.0.0'

gem 'sunspot_rails'
gem 'sunspot_solr' # optional pre-packaged Solr distribution for use in development

gem 'kaminari'

#group :test,:production do
#  gem 'therubyracer'
#end

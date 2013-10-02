source 'http://rubygems.org'

gem 'rails', '3.2.13'

gem 'mysql2'

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

#group :test,:production do
#  gem 'therubyracer'
#end

##### CUSTOM APPLICATION GEMS #####

### Rails 4 Compatible ###

# Change history
gem 'paper_trail' # Rails4 ok

# Forms
gem 'formtastic' #Rails4 ok

# User management
gem 'devise' # Rails4 ok

# Feature in Rails4
gem 'strong_parameters' # Rails4 ok

# Pagination
gem 'kaminari' # Rails4 ok

# Power-up tables
gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails' #Rails4 ok
gem 'jquery-ui-rails' #Rails4 ok

gem 'simple-navigation', github: 'andi/simple-navigation' # Rails4 ok

gem "paperclip", :git => "git://github.com/thoughtbot/paperclip.git" # Rails4 ok

gem 'delayed_job_active_record', github: 'collectiveidea/delayed_job_active_record' # Rails4 ok - with master branch
gem 'delayed_job_web' # Rails4 unknown



### Rails4 Unknown ###

# Generate tables automatically
gem 'table_helper', github: 'marcandre/table_helper' # Rails4 unknown - but should work

# add google analytics
gem 'google-analytics-rails' # Rails4 unknown - but should work

# auto grow textareas as you type
gem "autogrow-textarea-rails" # Rails4 unknown


### Rails4 might have problem!! ###

# authorization gem
gem 'cancan', github: 'ryanb/cancan', branch: '2.0' # Rails4 Unknown!!



#### Not dependant on Rails ###
gem 'hirb'
gem 'fancy_irb'
gem 'wirb'
gem "octave-ruby" # Rails4 unknown - but should work
#### Not dependant on Rails


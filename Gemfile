source 'http://rubygems.org'

if RUBY_VERSION =~ /2.1/ # assuming you're running Ruby ~1.9
   Encoding.default_external = Encoding::UTF_8
   Encoding.default_internal = Encoding::UTF_8
end

gem 'rails', '3.2.19'

gem 'pg'
#gem 'mysql2', '0.3.14'
#gem 'activerecord-mysql2-adapter'
# Gems used only for assets and not required
# in production environments by default.

group :assets do
    gem 'sass-rails',   '~> 3.2.3'
    gem 'modernizr-rails'
end
# !!!!!!!
# changed in order to allow js.coffee views being rendered in production mode
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
gem 'byebug', group: ['development','test']

gem 'test-unit'

group :test do
  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false
end

#group :test,:production do
#  gem 'therubyracer'
#end

##### CUSTOM APPLICATION GEMS #####

### Test Suite

gem "rspec-rails", :group => [:test, :development]
group :test do
  gem "factory_girl_rails" # Rails4 ok
  gem "capybara" # Rails4 ok
  gem "guard-rspec" # Rails4 ok
  gem "database_cleaner", '~>1' # Rails4 ok from v1.0.0
end


### Rails 4 Compatible ###

# Change history
gem 'paper_trail', '~>3.0.1' # Rails4 ok

# Forms
gem 'formtastic'#, github: 'justinfrench/formtastic', branch: 'master' #Rails4 ok

# User management
gem 'devise' # Rails4 ok

# Pagination
gem 'kaminari' # Rails4 ok

# Power-up tables
gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails' #Rails4 ok
gem 'jquery-ui-rails', '~>4.0.2'                                       #Rails4 ok

gem 'simple-navigation', '~>3.13.0' # Rails4 ok

gem "paperclip", '~>3.5.1' # Rails4 ok

gem 'delayed_job_active_record', github: 'collectiveidea/delayed_job_active_record' # Rails4 ok - with master branch
gem 'delayed_job_web' # Rails4 unknown
gem 'daemons'
# Feature in Rails4
gem 'strong_parameters' # Rails4 ok



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
gem "octave-ruby", github: 'mkfs/octave-ruby' # Rails4 unknown - but should work
#### Not dependant on Rails

gem 'roo' # for importing spreadsheets

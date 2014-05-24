source 'https://rubygems.org'

gem 'rails', '3.2.12'

gem 'mongoid', '~> 3.1.0'

gem 'jquery-rails'
gem 'backbone-on-rails', '0.9.2.1'
gem 'rabl'
gem 'yajl-ruby'

gem 'delayed_job_mongoid'
gem 'bson_ext'
gem 'devise'
gem 'simple_form'

gem "ckeditor", '~> 4.0.4', git: 'https://github.com/galetahub/ckeditor.git'
gem 'mongoid-paperclip', :require => 'mongoid_paperclip'
gem 'kaminari', "~> 0.14.1"

#gem 'math_engine', git: 'git://github.com/dmarczal/math_engine.git' #, branch: 'original'
gem 'math_engine', git: 'https://github.com/brightbits/math_engine.git' #, branch: 'original'

gem 'redcarpet'
gem 'whenever', require: false

gem 'request-log-analyzer', require: false
gem 'timelineJS-rails', '~> 1.1.5'

group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  #gem 'anjlab-bootstrap-rails', '>= 2.0', :require => 'bootstrap-rails' #, :git => 'git://github.com/anjlab/bootstrap-rails.git'
  gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails',
                                :git => 'git://github.com/dmarczal/bootstrap-rails.git'
                                #:git => 'git://github.com/anjlab/bootstrap-rails.git'
  gem 'font-awesome-sass-rails'
  gem 'handlebars_assets'
  gem 'marionette-rails'
end

gem 'bullet', group: :development
group :development, :test do
  gem 'pry-rails'
  gem 'thin'
  gem 'rspec-rails', '~> 2.0'
  gem 'capybara', '~> 2.2.0'
  gem 'selenium-webdriver',   '~> 2.35.1'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'thin'
  gem 'growl'
  gem 'faker'
  gem 'railroady'
end

group :test do
  gem 'spork', '> 0.9.0.rc'
  gem 'rb-fsevent', '~> 0.9'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'factory_girl_rails',  "~> 4.2.1"
end

gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'
gem 'rvm-capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

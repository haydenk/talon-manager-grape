source 'https://rubygems.org'
ruby RUBY_VERSION

gem 'aws-sdk', '~> 3'
gem 'sinatra', '~> 2.0', :require => 'sinatra/base'
gem 'sinatra-contrib', '~> 2.0'
gem 'grape', '~> 1.0'
gem 'grape-entity', '~> 0.6.1'
gem 'grape-swagger', '~> 0.27.3'
gem 'grape-swagger-entity', '~> 0.2.1'
gem 'grape-swagger-representable', '~> 0.1.4'
gem 'rack-cors', :require => 'rack/cors'
gem "rack-contrib", :require => "rack/contrib"
gem 'datamapper', '~> 1.2.0'
gem 'slim', '~> 3.0', '>= 3.0.9'
gem 'thin', '~> 1.7', '>= 1.7.2'
gem 'oj', '~> 3.6', '>= 3.6.6'
gem 'padrino-gen', '~> 0.14.3'
gem 'padrino-helpers', '~> 0.14.3'

group :development, :test do
  gem 'rake', '~> 12.0'
  gem 'airborne', '~> 0.2.13'
  gem 'capybara', '~> 3.6'
  gem 'launchy', '~> 2.4', '>= 2.4.3'
  gem 'pry', '~> 0.10.4'
  gem 'dm-sqlite-adapter', '~> 1.2.0'
end

group :production do
  gem 'dm-mysql-adapter', '~> 1.2.0'
end

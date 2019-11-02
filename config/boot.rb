ENV['RACK_ENV'] ||= 'development'

require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
require 'data_mapper' # metagem, requires common plugins too.
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

# Load the helpers
Dir['./app/helper/*.rb'].each { |f| require f }

if ENV['RACK_ENV'] == 'production'
  DataMapper.setup(:default, ENV['DATABASE_URL'])
else
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/app.db")
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models

# Load the models
Dir['./app/{model,entity}/*.rb'].each { |f| require f }
DataMapper.finalize

# Load the controllers
Dir['./app/controller/*.rb'].each { |f| require f }

module MySinatraApp
  class App < Grape::API
    version :v1, using: :accept_version_header, vendor: 'my-sinatra-app', cascade: false
    format :json
    helpers Sinatra::ApplicationHelpers

    mount MySinatraApp::UrlDownloadRequestController
    mount MySinatraApp::ScheduledRequestController
    add_swagger_documentation
  end
end

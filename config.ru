#\ -w -p 4567 -s thin
# encoding: utf-8
require_relative 'config/boot'
require 'rack/cors'

use Rack::Cors do
  allow do
    origins 'localhost:9000', '127.0.0.1:9000'
    resource '*',
             headers: '*',
             expose: ['Access-Control-Allow-Origin'],
             methods: [:get, :options],
             max_age: 600
  end
end
use Rack::TryStatic,
    :root => File.expand_path('../public', __FILE__),
    :urls => %w[/], :try => ['.html', 'index.html', '/index.html']

run Rack::Cascade.new [MySinatraApp::App]

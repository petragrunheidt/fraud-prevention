require 'sinatra'
require 'json'

set :port, 3000
set :bind, '0.0.0.0'

get '/' do
  content_type :json
  { message: 'Hello, world!' }.to_json
end

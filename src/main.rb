require 'grape'

class Main < Grape::API
  format :json
  get '/' do
    { hello: 'world' }
  end
end
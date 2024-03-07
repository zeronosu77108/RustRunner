require 'dotenv'
Dotenv.load

class ApiKeyChecker
  def initialize(app)
    @app = app
    @api_keys = ENV['API_KEYS'].split(',')
  end

  def call(env)
    request = Rack::Request.new(env)
    body = request.body.read
    api_key = JSON.parse(body)["api_key"]

    # ボディをenvに再設定
    env['rack.input'] = StringIO.new(body)

    if @api_keys.include?(api_key)
      @app.call(env)
    else
      [403, {'content-type' => 'text/plain'}, ['Invalid API Key']]
    end
  end
end

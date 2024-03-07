require './src/api_key_checker'
require './src/main'

require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'  # 全てのオリジンからのアクセスを許可する場合
    # origins 'example.com', 'foo.com'  # 特定のオリジンを指定する場合

    resource '*',
             headers: :any,
             methods: [:get, :post, :put, :delete, :options, :head],
             credentials: false  # Cookieなどの資格情報を含める場合はtrueにします
  end
end

use ApiKeyChecker
run Rack::Cascade.new [Main]
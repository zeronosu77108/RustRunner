require './src/api_key_checker'
require './src/main'

use ApiKeyChecker
run Rack::Cascade.new [Main]
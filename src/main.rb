require 'grape'
require 'open3'

class Main < Grape::API
  format :json
  get '/' do
    request = JSON.parse(Rack::Request.new(env).body.read)
    source_code = request['source_code']
    input = request['input']

    # main.rs にソースコードを書き込む
    File.open('/app/rust/src/main.rs', 'w') do |file|
      file.write(source_code)
    end

    # input.txt に入力を書き込む
    File.open('/app/rust/input.txt', 'w') do |file|
      file.write(input)
    end

    command = "cd /app/rust;"
    command += "/root/.cargo/bin/cargo run --release < input.txt"

    # 実行時間を計測する
    result, err, status = Open3.capture3(command)


    if status.exitstatus != 0
      return { error: err.to_s, result: result }
    end

    {
      result: result,
      time: (end_time - start_time)
    }
  end
end
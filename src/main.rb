require 'grape'
require 'open3'

class Main < Grape::API
  format :json
  post '/' do
    request_body = request.body.read
    request_payload = JSON.parse(request_body)

    source_code = request_payload['source_code']
    input = request_payload['input']

    # main.rs にソースコードを書き込む
    File.open('./rust/src/main.rs', 'w') do |file|
      file.write(source_code)
    end

    # input.txt に入力を書き込む
    File.open('./rust/input.txt', 'w') do |file|
      file.write(input)
    end

    command = "cd ./rust;"
    command += "/root/.cargo/bin/cargo run --release < input.txt"

    # 実行時間を計測する
    start_time = Time.now
    result, err, status = Open3.capture3(command)
    end_time = Time.now

    if status.exitstatus != 0
      return { error: err.to_s, result: result }
    end

    {
      result: result,
      time: (end_time - start_time)
    }
  end
end

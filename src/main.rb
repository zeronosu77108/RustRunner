require 'grape'
require 'open3'
require 'securerandom'

class Main < Grape::API
  format :json
  post '/' do
    request_body = request.body.read
    request_payload = JSON.parse(request_body)

    source_code = request_payload['source_code']
    input = request_payload['input']

    filename = SecureRandom.hex(10) + '.rs'
    # ソースコードを書き込む
    File.open("./rust/src/#{filename}", 'w') do |file|
      file.write(source_code)
    end

    input_filename = SecureRandom.hex(10) + '.txt'
    # 入力を書き込む
    File.open("./rust/#{input_filename}", 'w') do |file|
      file.write(input)
    end

    command = "cd ./rust;"
    command += "/root/.cargo/bin/cargo run --release < #{input_filename}"

    # 実行時間を計測する
    start_time = Time.now
    result, err, status = Open3.capture3(command)
    end_time = Time.now


    # 不要ファイルの削除
    File.delete("./rust/src/#{filename}")
    File.delete("./rust/#{input_filename}")

    if status.exitstatus != 0
      return { error: err.to_s, result: result }
    end

    {
      result: result,
      time: (end_time - start_time)
    }
  end
end

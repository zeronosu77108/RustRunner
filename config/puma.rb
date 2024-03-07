# config/puma.rb

# Pumaのスレッド数を設定
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 2 }
threads threads_count, threads_count

# デフォルトのポート（または環境変数から）
port ENV.fetch("PORT") { 9292 }

# モードを指定（デフォルトはdevelopment）
environment ENV.fetch("RACK_ENV") { "development" }

ssl_bind 'rust-runner.zeronosu77108.com', '443', {
  key: 'key',
  cert: 'cert'
}

# アプリケーションの場所を指定
app_dir = File.expand_path("../..", __FILE__)
directory app_dir

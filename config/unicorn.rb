application = 'twimodoki'

listen "/tmp/unicorn_#{application}.sock"
pid "/tmp/unicorn_#{application}.pid"

worker_processes 6
timeout 30
preload_app true

# capistrano 用に RAILS_ROOT を指定
working_directory "/var/www/#{application}/current"

if ENV['RAILS_ENV'] == 'production'
  shared_path = "/var/www/#{application}/shared"
  stderr_path = "#{shared_path}/log/unicorn.stderr.log"
  stdout_path = "#{shared_path}/log/unicorn.stdout.log"
end

# ログ
stderr_path File.expand_path('log/unicorn.log', ENV['RAILS_ROOT'])
stdout_path File.expand_path('log/unicorn.log', ENV['RAILS_ROOT'])

# ダウンタイムなくす
preload_app true

before_fork do |server, worker|
  # マスタープロセスの接続解除
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  # 古いマスタープロセスをkill
  old_pid = "#{ server.config[:pid] }.oldbin"
  unless old_pid == server.pid
    begin
      Process.kill :QUIT, File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  # preload_appするので必須
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end


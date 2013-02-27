# capistranoの出力に色がつく
require "capistrano_colors"
# デプロイ時にbundle installされる
require "bundler/capistrano"

# RVMの設定
# NOTE: ローカルではrvm使っていないのでこうしたが本当にいいのか？
require "rvm/capistrano"
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
set :rvm_ruby_string, '1.9.3'
set :rvm_type, :user

# アプリケーションの設定
set :user, "shin"
set :domain, "157.7.139.50"
set :application, "twimodoki"

# sudoを使うので設定
default_run_options[:pty] = true

# リポジトリの設定
set :scm, :git
set :repository, "ssh://#{user}@#{domain}/~/git/#{application}.git"
set :branch, "master"

# デプロイの設定
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"
set :rails_env, "production"

# 役割の設定
role :web, domain
role :app, domain
role :db, domain, :primary => true
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

# デプロイ後、パーミッションの修正
namespace :setup do
  task :fix_permissions do
    sudo "chown -R #{user}.#{user} #{deploy_to}"
  end
end
after "deploy:setup", "setup:fix_permissions"

# Unicorn用タスク
namespace :deploy do
  task :start, :roles => :app do
    run "cd #{current_path}; bundle exec unicorn_rails -c config/unicorn.rb -E #{rails_env} -D"
  end
  
  task :restart, :roles => :app do
    if File.exist? "/tmp/unicorn_#{application}.pid"
      run "kill -s USR2 `cat /tmp/unicorn_#{application}.pid`"
    end
  end
  
  task :stop, :roles => :app do
    run "kill -s QUIT `cat /tmp/unicorn.pid`"
  end
end


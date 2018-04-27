# config valid only for current version of Capistrano
lock '3.10.2'

set :application, 'agriculture_webapp'
set :repo_url, 'git@github.com:yhunglee/agriculture_webapp.git'
set :passenger_restart_with_touch, true

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'
set :deploy_to, '/var/www/agriculture_webapp'

# set :default_environment, {
#   'PATH' => "#{deploy_to}/bin:$PATH",
#   'GEM_HOME' => "#{deploy_to}/gems"
# }

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

# Set rvm type
#set :rvm_type, :user
set :rvm_custom_path, '/usr/share/rvm'

# Remote server using rvm
set :rvm_ruby_version, '2.4.1@rails5.2.0'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
 
  #desc 'Loading API routes of grape built.' 
  #after :finished do
  #  on roles(:all) do
	    # Execuate loading APIs' routes
#	    within release_path do
#		    execuate :rake, 'routes_with_grape'
#	    end
 #   end
 # end 

 # If you want to restart using `passenger-config restart-app`, add this to your config/deploy.rb,
 # set :passenger_restart_with_touch, false # Note that `nil` is NOT the same as `false` here
 set :passenger_restart_with_touch, false

 # If you are installing passenger during your deployment AND you want to restart using `passenger-config restart-app`,
 # you need to set `:passenger_in_gemfile` to `true` in your `config/deploy.rb`.
 set :passenger_in_gemfile, true

 
end

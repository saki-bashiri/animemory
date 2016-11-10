require 'capistrano/ext/multistage'\

set :domain, 'bluejays.dreamhost.com'

# ユーザの設定
set :repository, ''
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :deploy_subdir, "web"

set :keep_releases, 5

set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false
default_run_options[:pty] = true

def restart_file
  File.join(current_path, 'tmp', 'restart.txt')
end

#namespace :deploy do
#  task :restart, :roles => :app do
#    run "touch #{restart_file}"
#  end
#end

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, domain
role :app, domain
role :db, domain, :primary => true

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "mv -f #{File.join(current_path,'tmp','htaccess')} #{File.join(current_path,'public','.htaccess')}"
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end

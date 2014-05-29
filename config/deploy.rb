require 'bundler/capistrano'
require 'rvm/capistrano'

set :application, "Two Factor Auth"
set :repository,  'https://jpmermoz@github.com/jpmermoz/two_factor_auth.git'
set :deploy_to, '/var/www/jpmermoz.codingways.com'
set :scm, :git
set :deploy_via, :remote_cache
set :use_sudo, false
set :branch, 'master'
set :default_shell, '/bin/bash -l'
set :keep_releases, 2

#/************ SERVER INFORMATION ********/
set :location, '10.8.0.1'
set :port, 30000
set :user, 'jpmermoz'
role :web, location              
role :app, location   
role :db,  location, :primary => true 
#/***************************************/

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :seed do
    run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
  end
end

# ==============================
# Uploads
# ==============================

namespace :uploads do

  desc <<-EOD
    Creates the upload folders unless they exist
    and sets the proper upload permissions.
  EOD
  task :setup, :except => { :no_release => true } do
    dirs = uploads_dirs.map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
  end

  desc <<-EOD
    [internal] Creates the symlink to uploads shared folder
    for the most recently deployed version.
  EOD
  task :symlink, :except => { :no_release => true } do
    run "rm -rf #{release_path}/public/uploads"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end

  desc <<-EOD
    [internal] Computes uploads directory paths
    and registers them in Capistrano environment.
  EOD
  task :register_dirs do
    set :uploads_dirs,    %w(uploads)
    set :shared_children, fetch(:shared_children) + fetch(:uploads_dirs)
  end

  after       "deploy:finalize_update", "uploads:symlink"
  after       "deploy:update", "deploy:cleanup"
  on :start,  "uploads:register_dirs"

end

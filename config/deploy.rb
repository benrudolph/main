set :application, "benrudolph"
set :repository,  "https://github.com/benrudolph/main.git"
set :scm, :git
set :deploy_via, :remote_cache
set :user, :deploy
set :deploy_to, "/var/www/#{application}"
set :use_sudo, false
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}
default_run_options[:pty] = true

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :blog, "138.68.26.15"

set :ssh_options, { :forward_agent => true }

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :jekyll do
  task :generate, :roles => :blog do
    run "cd /var/www/#{application}/current && bundle install --without development"
    run "cd /var/www/#{application}/current && bundle exec jekyll build"
  end
end

after 'deploy:update_code', 'deploy:cleanup'
after 'deploy:create_symlink', 'jekyll:generate'

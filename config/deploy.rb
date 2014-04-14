# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'campaign_site'
set :deploy_user, 'seanot'

# setup repo details
set :scm, :git
set :repo_url, 'git@github.com/seanot/campaign_site.git'

#setup rbenv
set :rbenv_type, :system
set :rbenv_ruby, '2.0.0-p247'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#
{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w(rake gem bundle ruby)

# how many releases to keep
set :keep_releases, 5

set(:config_files, %w(
  unicorn.rb
  unicorn_init.sh
))

set(:executable_config_files, %w(
  unicorn_init.sh
))

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }



namespace :deploy do

  before :deploy, "deploy:check_revision"
  before :deploy, "deploy:run_tests"
  after 'deploy:symlink:shared', "deploy:compile_assets_locally"
  after :finishing, 'deploy:cleanup'

  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     # Your restart mechanism here, for example:
  #     # execute :touch, release_path.join('tmp/restart.txt')
  #   end
  # end

  after 'deploy:publishing', 'deploy:restart'

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end

end

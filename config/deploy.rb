# For more options, see http://capistranorb.com/documentation/getting-started/configuration/#
# config valid only for current version of Capistrano
lock '3.3.5'

# Change These To Order
set :application, 'openvault'
set :repo_url, 'https://github.com/WGBH/openvault3.git'



set :rails_env, 'production'


if ENV['BRANCH'] && ENV['BRANCH'].length > 0
  set :branch, ENV['BRANCH']
else
  ask :branch, 'master'
end

# Add the path to bundler, /home/ec2-user/bin, to $PATH env var.
set :linked_dirs, fetch(:linked_dirs, []).push('tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'tmp/downloads', 'jetty')
set :rails_env, :production
set :default_env, { 'PATH' => '$PATH:/home/ec2-user/bin' }
set :bundle_flags, '--deployment'
set :keep_releases, 1


# Require confirmation by user if the repo is in a dirty state.
include GitHelper
verify_git_status!

set :linked_dirs, fetch(:linked_dirs, []).push('log')
namespace :deploy do
  after :updated, :ensure_jetty_is_installed do
    invoke 'jetty:install'
  end
end

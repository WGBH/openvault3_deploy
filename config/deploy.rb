# For more options, see http://capistranorb.com/documentation/getting-started/configuration/#
# config valid only for current version of Capistrano
lock '3.3.5'
set :application, 'openvault'
set :repo_url, 'https://github.com/WGBH/openvault3.git'
set :rails_env, 'production'

if ENV['OV_BRANCH']
  set :branch, ENV['OV_BRANCH']
else
  ask :branch, 'master'
end

set :linked_dirs, fetch(:linked_dirs, []).push('log')
namespace :deploy do
  after :updated, :ensure_jetty_is_installed do
    invoke 'jetty:install'
  end
end

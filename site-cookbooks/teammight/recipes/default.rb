# -*- coding: utf-8 -*-
#
# Cookbook Name:: teammight
# Recipe:: default
#
# Copyright 2012, Dmytro Kovalov
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


app      = node[:teammight][:app]
user     = node[:teammight][:user]
home     = File.expand_path "~#{user}"
#
# Git committer setup done for the same user: teammight[:user]
#
config   = node[:git_committer][:node][:config][user]

#
# Re-use  github configuration from git_committer
# These configurations should be in sync.
github = config[:github]

src_dir  = "#{home}/#{app}"
repo     = github[:repository]
identity = File.expand_path config[:identity]

# Create directory layout. Here we use tree like:
# Application root:
# .
# ├── releases
# └── shared
#     ├── assets
#     ├── bundle
#     ├── config
#     │   └── couchdb.yml
#     ├── log
#     ├── pids
#     └── system

%w{ releases  shared }.each do |dir|
  directory "#{home}/apps/#{app}/#{dir}"do 
    owner node[:teammight][:user]
    group node[:teammight][:user]
    mode 0750
    action :create
    recursive true
  end
end

%w{ assets bundle config log pids system }.each do |dir|
  directory "#{home}/apps/#{app}/shared/#{dir}" do 
    owner node[:teammight][:user]
    group node[:teammight][:user]
    mode 0750
    action :create
    recursive true
  end
end

cookbook_file "#{home}/apps/#{app}/shared/config/couchdb.yml" do
  source "couchdb.yml"
  owner node[:teammight][:user]
  group node[:teammight][:user]
  mode 0644
  backup 0
end


cookbook_file "#{home}/.ssh/config" do
  source "ssh-config"
  owner node[:teammight][:user]
  group node[:teammight][:user]
  mode 0644
  backup 0
end

# Clone application repositorya and add branh in it for git_committer.
#
#  2 Actions below are chain triggered by :clone_app_repo and then by
# :git_branch. Only at the time of clone we should run it.
# ----------------------------------------------------------------------

execute :first_push do
  cwd src_dir
  command "git push origin #{node[:teammight][:branch]}"
  user user
  action :nothing
end

execute :git_branch do
  cwd src_dir
  command "git checkout -b #{node[:teammight][:branch]}"
  user user
  action :nothing
  notifies :run, resources(:execute => :first_push), :immediately
end



execute :clone_app_repo do
  cwd home
  user user
  command "test -f #{identity} && ssh-keyscan -t rsa,dsa github.com > #{home}/.ssh/known_hosts && ssh-agent /bin/bash -c 'ssh-add #{identity} && git clone #{repo} '"
  creates src_dir
  action :run
  notifies :run, resources(:execute => :git_branch), :immediately
end

#
# Delploy the app to localhost
# ----------------------------------------
# ...

execute :thin_start do 
  cwd src_dir
  command "thin -d start"
  user user
  group user
  action :nothing
end

# Capybara-webkit needs libqt4-dev
# FIXME: 
# http://stackoverflow.com/questions/9246786/how-can-i-get-chef-to-run-apt-get-update-before-running-other-recipes
execute "apt-get update"
package "libqt4-dev"

execute :bundle_install do 
  cwd src_dir
  command "bundle install"
  user user
  group user
  notifies :run, resources(:execute => :thin_start)
end

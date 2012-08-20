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

# FIXME:
# Assume there's only one user configured to use git_committer. 
#
user     = node[:git_committer][:node][:config].keys.first
home     = File.expand_path "~#{user}"
config   = node[:git_committer][:node][:config][user]

#
# Re-use  github configuration from git_committer
#
github = config[:github]

src_dir  = "#{home}/#{app}"
repo     = github[:repository]
identity = File.expand_path config[:identity]

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

execute "clone_app_repo" do
  cwd home
  user user
  command "test -f #{identity} && ssh-keyscan -t rsa,dsa github.com > #{home}/.ssh/known_hosts && ssh-agent /bin/bash -c 'ssh-add #{identity} && git clone #{repo} '"
  creates src_dir
  action :run
end



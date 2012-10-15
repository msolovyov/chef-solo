# -*- coding: utf-8 -*-
#
# Cookbook Name:: teammight
# Recipe:: developer
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

#
# Adds necessary setup for developer to start working: Pulls in
# repository and runs bundle install. On top of default
#

include_recipe "teammight::default"


#
# TODO: DRY'ify this - so, that it is 
#
app      = node[:teammight][:app]
user     = node[:teammight][:user]
home     = File.expand_path "~#{user}"
src_dir  = "#{home}/#{app}"
repo     = node[:teammight][:repo]
identity = File.expand_path "~/.ssh/#{node[:github_keys][:local][:identity]}"


execute :clone_app_repo do
  cwd home
  user user
  command "test -f #{identity} && ssh-keyscan -t rsa,dsa github.com > #{home}/.ssh/known_hosts && ssh-agent /bin/bash -c 'ssh-add #{identity} && git clone #{repo} '"
  creates src_dir
  action :run
  not_if Dir.exist? "#{src_dir}/#{app}"
  # notifies :run, resources(:execute => :git_branch), :immediately
end

# Capybara-webkit needs libqt4-dev
# FIXME: 
# http://stackoverflow.com/questions/9246786/how-can-i-get-chef-to-run-apt-get-update-before-running-other-recipes
execute "apt-get update"
package "libqt4-dev"

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

execute :bundle_install do 
  cwd src_dir
  command "bundle install"
  user user
  group user
  notifies :run, resources(:execute => :thin_start)
end

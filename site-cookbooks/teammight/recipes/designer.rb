# -*- coding: utf-8 -*-
#
# Cookbook Name:: teammight
# Recipe:: designer
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
# Additionally to developers' setup add, github commits, and strat web
# server.
#

# Clone application repository and add branch in it for git_committer.
#
#  2 Actions below are chain triggered by :clone_app_repo and then by
# :git_branch. Only at the time of clone we should run it.
# ----------------------------------------------------------------------

include_recipe "teammight::developer"

#
# TODO: DRY'ify this - so, that it is 
#
app      = node[:teammight][:app]
user     = node[:teammight][:user]
home     = File.expand_path "~#{user}"
src_dir  = "#{home}/#{app}"
repo     = node[:teammight][:repo]
identity = File.expand_path "~/.ssh/#{node[:github_keys][:local][:identity]}"

execute :first_push do
  cwd src_dir
  command "git push origin #{node[:teammight][:branch]}"
  user user
  action :nothing
end

execute :git_branch do
  cwd src_dir
  command "git checkout -B #{node[:teammight][:branch]}  --track"
  user user
  action :run
  notifies :run, resources(:execute => :first_push), :immediately
end

include_recipe "git_committer"




#
# Cookbook Name:: monit-unicorn
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

service "unicorn" do
  # For unicorn service we don't need it to be enabled, since it's
  # started from capistrano deployment and Monit only will start/stop
  # on its own events.

  #   action [:enable, :start]
  #   enabled true
  supports [:start, :restart, :stop]
end

template "/etc/init.d/unicorn" do
  owner "root"
  group "root"
  mode 0755
  source 'unicorn.init.erb'
end

template "/etc/monit/conf.d/unicorn.conf" do
  owner "root"
  group "root"
  mode 0700
  source 'unicorn.conf.erb'
  notifies :restart, resources(:service => "monit"), :delayed
end



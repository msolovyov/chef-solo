#
# Cookbook Name:: monit-nginx
# Recipe:: default
#
# Copyright 2012, Dmytro Kovalov
#
# Licenese: Apache 2.0
#

cookbook_file "/etc/monit/conf.d/nginx.conf" do
	source "nginx.conf"
	mode "0755"
	owner "root"
	group "root"
	notifies :restart, resources(:service => "monit"), :delayed
end

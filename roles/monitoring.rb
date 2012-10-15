name "monitoring"
description "The monitoring server"

override_attributes :munin => {
  "web_server" => "nginx",
  "server_auth_method" => "basic",
  "sysadmin_email" => "root@localhost"
}

default_attributes  :unicorn => {
  "pid" => "/home/ubuntu/apps/TeamMight/shared/pids/unicorn.pid"
}

run_list(
         "recipe[monit]",
         "recipe[monit-nginx]",
         "recipe[monit-unicorn]",
         "recipe[munin::server]",
         "recipe[munin::client]",
         "recipe[munin::unicorn]"
         )

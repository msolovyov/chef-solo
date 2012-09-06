 name "monitoring"
 description "The monitoring server"
 run_list(
          "recipe[munin::server]",
          "recipe[monit]",
          "recipe[monit-nginx]",
          "recipe[monit-unicorn]",
          "recipe[munin::server]",
          "recipe[munin::client]",
          "recipe[munin::unicorn]"
          )

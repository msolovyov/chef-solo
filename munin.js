{
  "munin" : {
	"web_server" : "nginx",
	"server_auth_method" : "basic",
	"sysadmin_email" : "root@localhost"
  },
  "run_list": [
    "recipe[munin::server]",
    "recipe[munin::client]",
    "recipe[munin::unicorn]"
  ]
}

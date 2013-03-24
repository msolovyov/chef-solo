name "Redis"
description "Redis key-value store"

default_attributes :redis => {
  "daemonize" => "yes",
  "pidfile"   => "/var/run/redis/redis-server.pid",
  'config_path'  => "/etc/redis.conf"
}

run_list ["recipe[redis]"] 





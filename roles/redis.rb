name "Redis"
description "Redis key-value store"

default_attributes :redis => {
  "daemonize" => "yes",
  "pidfile"   => "/var/run/redis/redis-server.pid"
}

run_list ["recipe[redis]"] 





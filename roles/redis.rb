name "Redis"
description "Redis key-value store"

default_attributes :redis => {
  "daemonize" => "yes"
}

run_list( ["recipe[redis]"] )





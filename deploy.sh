#!/bin/bash
# Copies files to the server and runs install.

host="${1}"
json="${2:-empty.json}"

if [ -z "$host" ]; then
    echo "Usage: ./deploy.sh [user@host] [json]"
    echo "\nEG: ./deploy.sh fred@192.168.1.1 web_server.json"
    echo "If no json is given it will default to epmty.json"
    exit
fi


# The host key might change when we instantiate a new VM, so
# we remove (-R) the old host key from known_hosts
echo 'keygen'
ssh-keygen -R "${host#*@}" 2> /dev/null

echo 'copy chef dir & run install.sh'
RSYNC_RSH="ssh -o 'StrictHostKeyChecking no'" rsync -ar --delete . ${host}:~/chef
ssh -t -o 'StrictHostKeyChecking no' "$host" " cd ~/chef && sudo bash install.sh $json"

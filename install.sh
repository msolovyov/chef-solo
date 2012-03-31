#!/bin/bash

json="${1}"

logfile="/root/chef-solo.log"

# This runs as root on the server
chef_binary="/usr/local/rvm/gems/ruby-1.9.3-p0/bin/chef-solo"


# Are we on a vanilla system?
if ! test -f "$chef_binary"; then

     export DEBIAN_FRONTEND=noninteractive

     # Upgrade headlessly (this is only safe-ish on vanilla systems)
     apt-get update -o Acquire::http::No-Cache=True
     apt-get -o Dpkg::Options::="--force-confnew" \
         --force-yes -fuy dist-upgrade

     # Install RVM as root (System-wide install)
     apt-get install -y build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion
     apt-get install libqt4-dev libqtwebkit-dev
     # Note system-wide installs are not in the RVM main version
     sudo bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
     sudo usermod -a -G rvm ubuntu #add the ubuntu user to the rvm group
     
     (cat <<'EOP'
[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm" # This loads RVM into a shell session.
EOP
     ) > /etc/profile.d/rvm.sh

     # Install Ruby using RVM
     [[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"
     rvm install ruby-1.9.3-p0
     rvm use ruby-1.9.3-p0 --default


     
     # Install chef
     gem install --no-rdoc --no-ri chef --version 0.10.0
    gem install --no-rdoc --no-ri bundler 
fi

# Run chef-solo on server
[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"
"$chef_binary" --config solo.rb --json-attributes "$json"

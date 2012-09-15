#!/bin/bash

json="${1}"

OS=$(uname -s)
RUBY="ruby-1.9.3-p194"

if [ $OS == 'Darwin' ]; then
    logfile="/var/root/chef-solo.log"
    chef_binary="${HOME}/.rvm/gems/${RUBY}/bin/chef-solo"
    RVM="${HOME}/.rvm/bin/rvm"
    
else

    logfile="/root/chef-solo.log"
    # This runs as root on the server
    chef_binary="/usr/local/rvm/gems/${RUBY}/bin/chef-solo"
    RVM="/usr/local/rvm/scripts/rvm"
fi


setup_rvm () {
    sudo bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
    sudo usermod -a -G rvm ubuntu #add the ubuntu user to the rvm group
    
    (cat <<-'EOP'
[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm" # This loads RVM into a shell session.
EOP
        ) > /etc/profile.d/rvm.sh

}


# Are we on a vanilla system?
if ! test -f "$chef_binary"; then

    case $OS in
        
        "Darwin")
            # In MacOSX RVM installed as a non-root into ~/.rvm directory
            bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
            
            #
            # Install Home brew
            #
            which brew > /dev/null || ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go)
            brew  install git openssl automake subversion lzlib homebrew/dupes/zlib
            
            ;; # end Darwin
        
        "Linux")
            
            BREED=$(awk '{if (NR == 1) print $1}' /etc/issue)
            
            case $BREED in
                
                "Ubuntu")
                    export DEBIAN_FRONTEND=noninteractive
                    
                    # Upgrade headlessly (this is only safe-ish on vanilla systems)
                    apt-get update -o Acquire::http::No-Cache=True
                    apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy dist-upgrade
                    
                    # Install RVM as root (System-wide install)
                    apt-get install -y build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion
                    
                    apt-get install libqt4-dev libqtwebkit-dev
                    
                    setup_rvm 
                    ;; # end Ubuntu
                    
                *) echo "Linux breed $BREED is not supported"; exit 1 ;;
            esac

            ;; # END Linux
        
        *)
            echo "Don't know this OS: $OS"
            exit 1
            ;;
    esac
    
    # Note system-wide installs are not in the RVM main version
    
    
    
    # Install Ruby using RVM
    [[ -s $RVM ]] && source $RVM
    rvm install ${RUBY}
    rvm use ${RUBY} --default
    
    # Install chef
    gem install --no-rdoc --no-ri chef --version 0.10.0
    gem install --no-rdoc --no-ri bundler 
fi

# Run chef-solo on server
[[ -s  $RVM ]] && source $RVM
"$chef_binary" --config solo.rb --json-attributes "$json"

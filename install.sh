#!/bin/bash
# vim: set noai ts=4 sw=4:

json="${1}"

OS=$(uname -s)

#
# Configuration: set required versions of rvm, ruby and chef
# below. Install script will install or upgrade versions as required.
# ----------------------------------------------------------------------
RVM=1.5.18
RUBY="ruby-1.9.3-p194"
CHEF="10.14.2"
# ----------------------------------------------------------------------


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



install_rvm() {
    # Are we on a vanilla system?
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
                    
                    sudo bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
                    sudo usermod -a -G rvm ubuntu #add the ubuntu user to the rvm group
                    
                    (cat <<-'EOP'
[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm" # This loads RVM into a shell session.
EOP
                        ) > /etc/profile.d/rvm.sh
                    ;; # end Ubuntu
		        "CentOS")

                    yum -y install bison gcc-c++ mhash mhash-devel mustang git

                    yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison iconv-devel ## NOTE: For centos >= 5.4 iconv-devel is provided by glibc

                    sudo bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
                    
                    (cat <<-'EOP'
[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm" # This loads RVM into a shell session.
EOP
                        ) > /etc/profile.d/rvm.sh
		            ;; # end CentOS
                *) echo "Linux breed $BREED is not supported"; exit 1 ;;
            esac

            ;; # END Linux
        
        *)
            echo "Don't know this OS: $OS"
            exit 1
            ;;
    esac
}

# Install Ruby using RVM
install_ruby () {
    # When attempting to install the same version that already exists,
    # rvm simply prints error and exits, so it's safe to run install
    # without checking.
    [[ -s $RVM ]] && source $RVM
    rvm install ${RUBY}
    rvm use ${RUBY} --default
    
}

# Install chef. Additionally to check whether binary exists, check
# also version of chef-solo.
# --------------------------------------------------------------------------------
install_chef () {

    if [ "$(chef-solo --version 2> /dev/null | awk '{print $2}')" != "${CHEF}" ]; then
        gem install --no-rdoc --no-ri chef --version ${CHEF}
        gem install --no-rdoc --no-ri bundler 
    fi

}

# --------------------------------------------------------------------------------
# End of functions. Start main part
# --------------------------------------------------------------------------------

test -f $chef_binary ||  install_rvm 

# TODO [ $(rvm --version 2>/dev/null | awk ' $1 ~ /rvm/ {print $2}') == ${RVM} ] || update_rvm
install_ruby
install_chef
#
# Run chef-solo on server
#
[[ -s  $RVM ]] && source $RVM
"$chef_binary" --config solo.rb --json-attributes "$json"

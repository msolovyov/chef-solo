#!/usr/bin/env bash
# vim: set noai ts=4 sw=4:
#
# RVM fails with /usr/local/rvm/scripts/rvm: line 11: ZSH_VERSION: unbound variable
#set -o nounset                  # exit on unset variables 
#set -o errexit                  # exit on shell error

json="${1:-empty.json}"

OS=$(uname -s)
BITS=$(uname -m)
# Set some defaults
#
RUBY=${RUBY:-"1.9.3-p392"}
CHEF=${CHEF:-"10.24.0"}
HOME=${HOME:-"/home/$(whoami)"}

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin export PATH

# Source custom configuration from external file

source install.conf


# ------------------------------------------------------------------
if [ ${OS} == 'Darwin' ]; then
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
    case ${OS} in

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

            case ${BREED} in

                # ----------
                "Ubuntu"|"Debian")
                # ----------
                    export DEBIAN_FRONTEND=noninteractive

                    # Upgrade headlessly (this is only safe-ish on vanilla systems)
                    apt-get update -o Acquire::http::No-Cache=True
                    apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy dist-upgrade

                    # Install RVM as root (System-wide install)
                    apt-get install -y build-essential openssl libreadline6 libreadline6-dev \
                        curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 \
                        libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev \
                        ncurses-dev automake libtool bison subversion libgdbm-dev pkg-config \
                        libffi-dev nodejs libqt4-dev libqtwebkit-dev

                    sudo usermod -a -G rvm ubuntu #add the ubuntu user to the rvm group

                    ;; # end Ubuntu
                # ----------
                "CentOS"|"RedHat")
                # ----------
                    if [ ! -z ${VAULT} ]; then # See conmment about VAULT in install.conf
                        \cp -f ${VAULT} /etc/yum.repos.d
                    fi

                    which lsb_release > /dev/null
                    if [ $? == 0  ]; then
                        RELEASE="el$(lsb_release -rs | cut -c1)"
                    else
                        RELEASE="el$(head -1 /etc/issue | tr -d \"[:alpha:][:punct:][:space:]\"| cut -c1)"
                    fi

                    rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt

                    # This is the name of RPM file
                    RPMFORGE=rpmforge-release-${RPMFORGE_RELEASE}.${RELEASE}.rf.${BITS}.rpm

                    # rpm install from http://.. fails sometimes, it's
                    # safer to dowload first, then install from file

                    # Make sure wget is installed
                    rpm -q wget > /dev/null || yum install -y wget
                    #
                    \rm -f /tmp/${RPMFORGE}
                    wget http://packages.sw.be/rpmforge-release/${RPMFORGE} -O /tmp/${RPMFORGE} || exit
                    rpm -Uhv /tmp/${RPMFORGE} || true

                    yum -y install bison gcc-c++ mhash mhash-devel mustang git 

                    ## NOTE: For centos >= 5.4 iconv-devel is provided by glibc
                    yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel \
                        libyaml-devel libffi-devel openssl-devel make bzip2 autoconf \
                        automake libtool bison iconv-devel mysql-devel sqlite-devel
                    
                    ;; # end CentOS


                *) echo "Linux breed ${BREED} is not supported"; exit 1 ;;
            esac

            curl -L https://get.rvm.io | sudo bash -s stable --ruby=${RUBY} --autolibs=enabled --auto-dotfiles

            (cat <<-'EOP'
# This loads RVM into a shell session.
[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"
EOP
                ) > /etc/profile.d/rvm.sh
            ;; # END Linux

        *)
            echo "Don't know this OS: ${OS}"
            exit 1
            ;;
    esac
}

# Install Ruby using RVM
install_ruby () {
    # When attempting to install the same version that already exists,
    # rvm simply prints error and exits, so it's safe to run install
    # without checking.

    [[ -s ${RVM} ]] && source ${RVM}
    rvm list strings | grep -E "^${RUBY}$" 2>&1 > /dev/null || rvm install ${RUBY} --autolibs=enable || true
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

    # FIX for the moneta error See KNOWN_PROBLEMS #3
    local MAJOR=$(echo ${CHEF} | cut -d\. -f1)
    if [ ${MAJOR} == 10 ]; then
        MONETA=$(gem list --local moneta | sed 's/moneta//' | tr -d ' \i')
        if [ "${MONETA}" != '(0.6.0)' ]; then
            gem uninstall moneta --all --force
            gem install moneta --version=0.6.0
        fi
    fi

}

#
# Rubygems - as of may/2013, Rubygems need to be downgraded when used
# with Ruby 2.x and Chef 11.
# -----------------------------------------------------------------------------

update_rubygems () {
    if [[ ! -z ${RUBYGEMS} ]]; then 
        local CURRENT=$(gem --version)
        if [[ "${CURRENT}" != "${RUBYGEMS}" ]]; then
            gem update --system ${RUBYGEMS};                   # See KNOWN_PROBLEMS #1
            gem install --no-rdoc --no-ri json --version=1.7.7 # See KNOWN_PROBLEMS #2
        fi
    fi    
}

# --------------------------------------------------------------------------------
# End of functions. Start main part
# --------------------------------------------------------------------------------

test -f ${chef_binary} ||  install_rvm

install_ruby
install_chef
update_rubygems

#
# Run chef-solo on server
#
[[ -s  ${RVM} ]] && source ${RVM} || true
# https://gist.github.com/deepak/4620395#file-cannot-find-solo-rb-txt-L11
"${chef_binary}" --config $(pwd|tr -d "\n")/solo.rb --json-attributes "${json}"

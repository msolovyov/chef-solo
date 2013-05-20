
Chef-solo
===========

Bootstrapping Ruby or Ruby on Rails server on a Linux/MacOSX machine. Bootstrapping installs prerequisite for RVM, RVM itself, Ruby and Chef. At the end script executes chef-solo using provided JSON configuration file.

Usage
----------

### Remotely

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
./deploy.sh <user>@<host> <json>
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
json - This is optional. I've put this there so you can have different server setup config files. e.g.: web_server.json

There's empty JSON file, included now. If you need only install RVM, Ruby and Chef, run as:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
./deploy.sh ... empty.json
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   
### Locally

You can simply bootstrap your local machine if you need to. In this case you'd need root or sudo access and networking setup only. Instead of using `./deploy.sh` script, use `./install.sh` as:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
[sudo] bash ./install.sh <JSON>
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Requirements
------------

* Clean install server machine with password less SSH access and password less sudo for your user for remote installation.
* curl
* sudo

Cookbooks
-----------

Script uses [librarian gem](https://github.com/applicationsonline/librarian-chef) to manage Chef cookbooks. Cookbook's are downloaded into `./cookbooks` directory. You can also use own cookbooks, managed manually and installed in `./site-cookbooks`. 

To use librarian, after updating `Cheffile` file, run in the repository directory:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
 bundle install                       # Installs librarian
 librarian-chef install               # Installs cookbooks
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


## Supported by install.sh 

### OS's:

* MacOS (Darwin)
* Debian (Same group as Ubuntu) 
* RHEL/CentOS with Rpmforge

### Tested with

* OS
  * MacOSX 10.7.x
  * CentOS 5.8
  * Debian 6.x
  * Ubuntu 10.x, 12.x
  
* Ruby
  * 1.9.3-pXXX
  * 2.0.0-p0, p195
  
* Chef
  * 0.10.x, 10.x
  * 11.4.x

## Configuration

### Install.conf

File install.conf Contains fallowing configuration for install.sh script:

* RVM version
* Ruby version
* Chef version
* RPM forge release for CentOS/RHEL
* Rubygems - as of may/2013, Rubygems need to be downgraded when used with Ruby 2.x and Chef 11. Corresponding section added.

### solo.rb

Solo.rb is configuration file for `chef-solo` binary. Contains PATH information for cookbooks, roles, logs.
  

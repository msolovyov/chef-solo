
Chef-solo
----------

Bootstrapping files for creating a Ruby on Rails server on an Ubuntu 10.04 LTS machine

Requirements
------------

Blank Ubuntu 10.04 server machine with passwordless SSH access and passwordless sudo for your user.

Additions 
=========

by @dmytro


### Added support to install.sh for following OS's:

* MacOS (Darwin)
* Debian (Same group as Ubuntu) 
* RHEL/CentOS with Rpmforge

### Tested with

* MacOSX 10.7.x
* CentOS 5.8
* Debian 6.x
* Ubuntu 10.x, 12.x

### Added configuration in the `install.sh` script for:

* RVM version
* Ruby version
* Chef version
* RPM forge release for CentOS/RHEL

Running
----------

```
./deploy <user>@<host> <json>

```    
    
json - This is optional. I've put this there so you can have different server setup config files. eg: web_server.json

There's empty JSON file, included now. If you need only install RVM, Ruby and Chef, run as:

```

./deploy ... empty.json

```
   

   
  

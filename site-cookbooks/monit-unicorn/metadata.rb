maintainer       "Dmytro Kovalov"
maintainer_email "dmytro.kovalov@gmail.com"
license          "Apache 2.0"
description      "Configures monit to monitor unicorn master and childrens"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
depends          "monit"

attribute "rails/path",
  :description => 'Path to Rails application',
  :type => "string",
  :required => "recommended"

attribute "rails/user",
  :description => 'UNIX user id to run Rails application',
  :type => "string",
  :required => "recommended"

attribute "unicorn/max_memory",
  :description => 'Max ammount of memory when Unicorn child is restarted',
  :type => "string",
  :required => "recommended"
  

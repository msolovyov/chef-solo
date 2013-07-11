
# #3
======================

* Known bug with Chef and Moneta. http://tickets.opscode.com/browse/CHEF-3721

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 FATAL: LoadError: cannot load such file -- moneta/basic_file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Report says it's with  Chef 10.16 and fix would be to install moneta version < 0.7. But people are reporting same problem with Chef 10.12, too.

During deployment moneta 0.7.12 is pulled up from some of the dependencies (please see below). I am trying to figure out which one is it. Looks like it's because of Chef defaullting to 10.14

* Fix: for Chef 10.x downgrade moneta to 0.6.0


# #1 May/19 2013
======================

Rubygems - as of may/2013, Rubygems need to be downgraded when used with Ruby 2.x and Chef 11. Corresponding section added.

* Ruby 2.0.0-p0, p195, Chef 11.4.4, Rubygems 2.0.0
* Error message:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

/usr/local/rvm/rubies/ruby-2.0.0-p195/lib/ruby/site_ruby/2.0.0/rubygems/core_ext/kernel_require.rb:45:in `require': cannot load such file -- rubygems/format (LoadError)

        from /usr/local/rvm/rubies/ruby-2.0.0-p195/lib/ruby/site_ruby/2.0.0/rubygems/core_ext/kernel_require.rb:45:in `require'
        from /usr/local/rvm/gems/ruby-2.0.0-p195/gems/chef-11.4.4/lib/chef/provider/package/rubygems.rb:34:in `<top (required)>'
        from /usr/local/rvm/rubies/ruby-2.0.0-p195/lib/ruby/site_ruby/2.0.0/rubygems/core_ext/kernel_require.rb:45:in `require'
        from /usr/local/rvm/rubies/ruby-2.0.0-p195/lib/ruby/site_ruby/2.0.0/rubygems/core_ext/kernel_require.rb:45:in `require'
        from /usr/local/rvm/gems/ruby-2.0.0-p195/gems/chef-11.4.4/lib/chef/providers.rb:60:in `<top (required)>'
        from /usr/local/rvm/rubies/ruby-2.0.0-p195/lib/ruby/site_ruby/2.0.0/rubygems/core_ext/kernel_require.rb:45:in `require'
        from /usr/local/rvm/rubies/ruby-2.0.0-p195/lib/ruby/site_ruby/2.0.0/rubygems/core_ext/kernel_require.rb:45:in `require'
        from /usr/local/rvm/gems/ruby-2.0.0-p195/gems/chef-11.4.4/lib/chef.rb:25:in `<top (required)>'
        from /usr/local/rvm/rubies/ruby-2.0.0-p195/lib/ruby/site_ruby/2.0.0/rubygems/core_ext/kernel_require.rb:45:in `require'
        from /usr/local/rvm/rubies/ruby-2.0.0-p195/lib/ruby/site_ruby/2.0.0/rubygems/core_ext/kernel_require.rb:45:in `require'
        from /usr/local/rvm/gems/ruby-2.0.0-p195/gems/chef-11.4.4/lib/chef/application/solo.rb:19:in `<top (required)>'
        from /usr/local/rvm/rubies/ruby-2.0.0-p195/lib/ruby/site_ruby/2.0.0/rubygems/core_ext/kernel_require.rb:45:in `require'
        from /usr/local/rvm/rubies/ruby-2.0.0-p195/lib/ruby/site_ruby/2.0.0/rubygems/core_ext/kernel_require.rb:45:in `require'
        from /usr/local/rvm/gems/ruby-2.0.0-p195/gems/chef-11.4.4/bin/chef-solo:23:in `<top (required)>'
        from /usr/local/rvm/gems/ruby-2.0.0-p195/bin/chef-solo:23:in `load'
        from /usr/local/rvm/gems/ruby-2.0.0-p195/bin/chef-solo:23:in `<main>'
        from /usr/local/rvm/gems/ruby-2.0.0-p195/bin/ruby_noexec_wrapper:14:in `eval'
        from /usr/local/rvm/gems/ruby-2.0.0-p195/bin/ruby_noexec_wrapper:14:in `<main>'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

* Fix: downgrade Rubygems

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        gem update --system 1.8.25
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## #2 May/20 2013
======================


* Ruby 2.0.0-p195, Rubygems 1.8.5

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/usr/local/rvm/rubies/ruby-2.0.0-p195/lib/ruby/site_ruby/2.0.0/rubygems/dependency.rb:247:in
`to_specs': Could not find json (<= 1.7.7, >= 1.4.4) amongst
[bundler-1.3.5, chef-11.4.4, erubis-2.7.0, highline-1.6.19,
ipaddress-0.8.0, mime-types-1.23, mixlib-authentication-1.3.0,
mixlib-cli-1.3.0, mixlib-config-1.1.2, mixlib-log-1.6.0,
mixlib-shellout-1.1.0, net-ssh-2.6.7, net-ssh-gateway-1.2.0,
net-ssh-multi-1.1, ohai-6.16.0, rake-10.0.4, rest-client-1.6.7,
rubygems-bundler-1.1.1, rubygems-update-1.8.25, rvm-1.11.3.7,
systemu-2.5.2, yajl-ruby-1.1.0] (Gem::LoadError)

        from /usr/local/rvm/rubies/ruby-2.0.0-p195/lib/ruby/site_ruby/2.0.0/rubygems/specification.rb:778:in `block in activate_dependencies'
        from /usr/local/rvm/rubies/ruby-2.0.0-p195/lib/ruby/site_ruby/2.0.0/rubygems/specification.rb:767:in `each'
        from /usr/local/rvm/rubies/ruby-2.0.0-p195/lib/ruby/site_ruby/2.0.0/rubygems/specification.rb:767:in `activate_dependencies'
        from /usr/local/rvm/rubies/ruby-2.0.0-p195/lib/ruby/site_ruby/2.0.0/rubygems/specification.rb:751:in `activate'
        from /usr/local/rvm/rubies/ruby-2.0.0-p195/lib/ruby/site_ruby/2.0.0/rubygems.rb:1232:in `gem'
        from /usr/local/rvm/gems/ruby-2.0.0-p195/bin/chef-solo:22:in `<main>'
        from /usr/local/rvm/gems/ruby-2.0.0-p195/bin/ruby_noexec_wrapper:14:in `eval'
        from /usr/local/rvm/gems/ruby-2.0.0-p195/bin/ruby_noexec_wrapper:14:in `<main>'        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        

* Fix: install json 1.7.7

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        gem install --no-rdoc --no-ri json --version=1.7.7
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


root = File.absolute_path(File.dirname(__FILE__))
 
file_cache_path root
cookbook_path [root + '/cookbooks', '/home/michael/dev/chef/cookbooks', root + '/site-cookbooks']
role_path root + "/roles"
data_bag_path root + "/data_bags"
log_level :info
log_location STDOUT


default.git_committer.repo        = "https://github.com/dmytro/git_committer.git"

default.git_committer.user       = 'root'
default.git_committer.dirname    = '.git_committer'

#
# If this is present will create config file for the node where
# deployment is done. If not need to provide git_committer.yml config
# file.
#
# This is just example. Please either write your configuration below,
# or override it within *.json file
# default.git_committer.node.config  = \
# { :ubuntu => # UNIX user name on the host
#   { :directory => '/home/ubuntu/test',
#     :identity => "~/.ssh/git_committer",
#     :github => { 
#       :repository  => 'git@github.com:user/repo',
#       :user => 'gihub-uer', 
#       :password => 'SECRET',
#       :create_key => true,
#       :branch => 'auto-commit-branch',
#       :setup_branch => true,
#     }
#   }
# }


# default.git_committer.config.gituhub.user       = 
# default.git_committer.config.gituhub.password   = 
# default.git_committer.config.gituhub.create_key = 
# default.git_committer.config.gituhub.upload_key = 


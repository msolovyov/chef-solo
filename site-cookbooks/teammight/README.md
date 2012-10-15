Description
===========

This cookbook has three different recipies:

- default: only creates basic layout for app deployment, creates subdirectories for deployment, installs SSH keys, and copies keys to Github. After completion this recipe, application can be deployed to this host.

- developer - aditionally to the above creates development directory and checks out source code from github. It also runs `bundles install` and strarts `Thin` werbserver.

- designer - Prepares server for work by designers. Assumed designers are not falmiliar with git and github and CLI. Additionally to the above, add crontab entries for automatic comitting to gihub, and creates branch for automatic commits.


Note: `teammight::default` recipe is included in `teammight::developer`, `teammight::designer` is included into developer's recipe.

In JSON config file it can be specified as:

````json
{
    "run_list": [
        "recipe[teammight::designer]"
    ]
}
````


Development directory is created as `/home/ubuntu/<APP_NAME>`, while deployment directory is created as `/home/ubuntu/apps/<APP_NAME>` directory layout. Here we use tree like:

````
 Application root:
 .
 ├── releases
 └── shared
     ├── assets
     ├── bundle
     ├── config
     │   └── couchdb.yml
     ├── log
     ├── pids
     └── system
````


Requirements
============

Attributes
==========

Usage
=====


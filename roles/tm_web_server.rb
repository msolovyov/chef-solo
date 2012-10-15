name "web_server"
description "Builds a web server for Rails apps"
run_list( [
           "recipe[nginx]",
           "recipe[couchdb]",
           "recipe[git]",
           "recipe[github_keys]",
           "recipe[wkhtmltopdf]"
           ]
           )

override_attributes "github_keys" => {
  "local" => {
    "user" => "ubuntu",
    "identity"=> "id_dsa" 
  }
}                

override_attributes "github"=> {
  "repository"=> "git@github.com=>dmytro/TeamMight.git"
}

override_attributes "rails"=> {
  "path" => "/home/ubuntu/apps/TeamMight"
}


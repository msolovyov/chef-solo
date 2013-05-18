name 'github_keys'

description "Onnly installs git keys for deployment"

default_attributes "github_keys" => {
  "local" => {
    "user" => "ubuntu",
    "identity"=> "id_dsa"
  }
}

run_list( [
           "recipe[git]",
           "recipe[github_keys]"
           ]
           )



name 'tm_production'

description "Prduction server includes web server, necessary components, monitoring and environment prepared for deployment"

default_attributes "github_keys" => {
  "local" => {
    "user" => "ubuntu",
    "identity"=> "id_dsa"
  }
}

run_list(
        "role[tm_web_server]",
        "role[monitoring]",
        "recipe[teammight]"
         )

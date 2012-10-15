name 'tm_production'

description "Prduction server includes web server, necessary components, monitoring and environment prepared for deployment"

run_list(
        "role[tm_web_server]",
        "role[monitoring]",
        "recipe[teammight]"
         )

name 'nginx_webserver'

description "Nginx web server, others components, monitoring and environment prepared for deployment"

run_list(
         "recipe[nginx]",
         "recipe[git]",
         "role[monitoring]"
         )





name 'tm_developer'

description "Web server for development includes web server and
necessary components, application repository form Github"

run_list(
        "role[tm_web_server]",
        "recipe[teammight::developer]"
         )

name 'tm_designer'

description "Web server for designers includes everything from developer, plus automatic git commits"

default_attributes "teammight" => { "branch" => 'ie-cleanups' }

run_list(
        "role[tm_web_server]",
        "recipe[teammight::developer]",
        "recipe[teammight::designer]"
         )

name 'tm_developer'

description "Web server for designers includes everything from developmer, plus automatic git commits"

run_list(
        "role[tm_web_server]",
        "recipe[teammight::designer]"
         )

name "elasticsearch"
description "Elastic Search includes ES itself and Java"


run_list [
          "recipe[java]",
          "recipe[elasticsearch]"
         ] 





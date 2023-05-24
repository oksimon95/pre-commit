#!/bin/zsh
apps=($(ls environments/prod/us-east-1 | rg -v ".log|.hcl"))
old_apps=$(cat Jenkinsfile | rg -o -U --color=never "(\[)(\n.*)+(\])")
current_apps="["
for app in $apps
do
  current_apps="${current_apps}\n    \"$app\","
done
current_apps="${current_apps}\n]"
old_jenkinsfile=$(cat Jenkinsfile)
new_jenkinsfile=${old_jenkinsfile/$old_apps/$current_apps}
echo $new_jenkinsfile > Jenkinsfile
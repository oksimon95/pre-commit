#!/bin/zsh
apps=($(ls environments/dev/us-east-1 | rg -v ".log|.hcl"))

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

old_teardown_apps=$(cat TeardownJenkinsfile | rg -o -U --color=never "(\[)(\n.*)+(\])")
current_teardown_apps="["
for teardown_app in $apps
do
  current_teardown_apps="${current_teardown_apps}\n    \"$teardown_app\","
done
current_teardown_apps="${current_teardown_apps}\n]"
old_teardown_jenkinsfile=$(cat TeardownJenkinsfile)
new_teardown_jenkinsfile=${old_teardown_jenkinsfile/$old_apps/$current_apps}
echo $new_teardown_jenkinsfile > TeardownJenkinsfile
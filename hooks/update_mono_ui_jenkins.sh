#!/bin/zsh
if [[ $(command -v rg) == '' ]]; then
  brew install rg
fi
apps=($(ls environments/test/us-east-1 | rg -v ".log|.hcl" | sed "s/ /\n/g" | sort | xargs))

old_apps=$(cat Jenkinsfile | rg -o -U --color=never "(\[)(\n.*)+(\])")
old_apps_list=$(echo $old_apps | grep ',' | sed "s/,//g" | sort | xargs)

jenkinsfile_updated=false
teardown_jenkinsfile_updated=false

if [[ $apps != $old_apps_list ]]; then
  current_apps="["
  for app in $apps
  do
    current_apps="${current_apps}\n    \"$app\","
  done
  current_apps="${current_apps}\n]"
  old_jenkinsfile=$(cat Jenkinsfile)
  new_jenkinsfile=${old_jenkinsfile/$old_apps/$current_apps}
  echo $new_jenkinsfile > Jenkinsfile
  jenkinsfile_updated=true
fi

old_teardown_apps=$(cat TeardownJenkinsfile | rg -o -U --color=never "(\[)(\n.*)+(\])")
old_teardown_apps_list=$(echo $old_teardown_apps | grep ',' | sed "s/,//g" | sort | xargs)

if [[ $apps != $old_teardown_apps_list ]]; then
  current_teardown_apps="["
  for teardown_app in $apps
  do
    current_teardown_apps="${current_teardown_apps}\n    \"$teardown_app\","
  done
  current_teardown_apps="${current_teardown_apps}\n]"
  old_teardown_jenkinsfile=$(cat TeardownJenkinsfile)
  new_teardown_jenkinsfile=${old_teardown_jenkinsfile/$old_teardown_apps/$current_apps}
  echo $new_teardown_jenkinsfile > TeardownJenkinsfile
  teardown_jenkinsfile_updated=true
fi

if ($jenkinsfile_updated) || ($teardown_jenkinsfile_updated) ; then
  if ($jenkinsfile_updated); then
    echo "Updated Jenkinsfile Apps!"
  fi
  if ($teardown_jenkinsfile_updated); then
    echo "Updated TeardownJenkinsfile Apps!"
  fi
  false
fi
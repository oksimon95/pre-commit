#!/bin/zsh
if [[ $(command -v rg) == '' ]]; then
  brew install ripgrep
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

if ($jenkinsfile_updated); then
  if ($jenkinsfile_updated); then
    echo "Updated Jenkinsfile Apps!"
  fi
  false
fi
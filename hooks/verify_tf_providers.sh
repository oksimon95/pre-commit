#!/bin/zsh
if [[ $(command -v hcl2json) == '' ]]; then
  brew install hcl2json
fi
current_path=$(pwd)
tf_lock_updated=true
if [ -d 'modules' ]; then
  local sub_modules=($(ls -d modules/*/))
  if [[ $sub_modules != '' ]]; then
    for sub_mod in $sub_modules
    do
      cd "$current_path/$sub_mod"
      providers=($(hcl2json .terraform.lock.hcl | jq -r ".provider | to_entries[] | .key" | xargs))
      for provider in $providers
      do
        number_of_platforms=$(hcl2json .terraform.lock.hcl | jq -r ".provider.\"$provider\"[].hashes[]" | grep --color=never "h1:" | wc -l | xargs)
        if [ $number_of_platforms -lt 4 ]; then
          terraform init > /dev/null 2>&1
          rm -rf .terraform.lock.hcl
          terraform providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64 -platform=darwin_arm64
          tf_lock_updated=false
        fi
      done
    done
  fi
fi
cd $current_path
providers=($(hcl2json .terraform.lock.hcl | jq -r ".provider | to_entries[] | .key" | xargs))
for provider in $providers
do
  number_of_platforms=$(hcl2json .terraform.lock.hcl | jq -r ".provider.\"$provider\"[].hashes[]" | grep --color=never "h1:" | wc -l | xargs)
  if [ $number_of_platforms -lt 4 ]; then
    terraform init > /dev/null 2>&1
    rm -rf .terraform.lock.hcl
    terraform providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64 -platform=darwin_arm64
    tf_lock_updated=false
  fi
done
eval "$tf_lock_updated"
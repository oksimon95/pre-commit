#!/bin/zsh
if [[ $(command -v hcl2json) == '' ]]; then
  brew install hcl2json
fi
providers=($(hcl2json .terraform.lock.hcl | jq -r ".provider | to_entries[] | .key" | xargs))
for provider in $providers
do
  number_of_platforms=$(hcl2json .terraform.lock.hcl | jq -r ".provider.\"$provider\"[].hashes[]" | grep --color=never "h1:" | wc -l | xargs)
  if ! [ $number_of_platforms -eq 3 ]; then
    terraform init > /dev/null 2>&1
    rm -rf .terraform.lock.hcl
    terraform providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64
    git add .terraform.lock.hcl
    false
  fi
done

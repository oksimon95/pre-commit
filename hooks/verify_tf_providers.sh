#!/bin/zsh
if ! [ $(hcl2json .terraform.lock.hcl | jq -r ".provider.\"registry.terraform.io/hashicorp/aws\"[].hashes[]" | grep --color=never "h1:" | wc -l | xargs) -eq 3 ]; then
  terraform init > /dev/null 2>&1
  rm -rf .terraform.lock.hcl
  terraform providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64
  false
fi

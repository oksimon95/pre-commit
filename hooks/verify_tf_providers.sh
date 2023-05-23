#!/bin/sh
number_of_platforms=$(hcl2json .terraform.lock.hcl | jq -r ".provider.\"registry.terraform.io/hashicorp/aws\"[].hashes[]" | grep --color=never "h1:" | wc -l | xargs)
if ! [ $number_of_platforms -eq 3 ]; then
  terraform init > /dev/null 2>&1
  rm -rf .terraform.lock.hcl
  terraform providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64 > /dev/null 2>&1
  echo "Updated terraform lock file providers for multiple platforms"
  false
fi

#!/bin/bash

set -o pipefail
set -e

# This script runs terraform plan with input set to false and no color outputs, suitable for running as part of a CI/CD pipeline.
# You need to pass through a Terraform directory as an argument, e.g.
# sh terraform-plan.sh terraform/environments

# This script pipes the output of terraform plan to ./scripts/redact-output.sh to redact sensitive things, such as AWS keys if they
# are exposed via terraform plan.

# Make redact-output.sh executable
chmod +x $(dirname $0)/redact-output.sh

project_dir=$1
shift

if [ -z "$project_dir" ]; then
  echo "Unsure where to run terraform, exiting"
  exit 1
fi

terraform -chdir="$project_dir" plan -input=false -no-color $@ | $(dirname $0)/redact-output.sh

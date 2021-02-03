#!/bin/bash
set -e

TERRAFORM_VERSION=0.14.5
echo "# build docker cli/terraform $TERRAFORM_VERSION"
make build

echo "# install local terraform $TERRAFORM_VERSION"
scripts/install-terraform.sh $TERRAFORM_VERSION

export TF_BIN=bin/terraform
export PROJECT=terraform-examples/app-docker
export TF_IN_AUTOMATION=true

echo "# init"
make TF_BIN=$TF_BIN PROJECT=$PROJECT init

echo "# deploy default (blue)"
make TF_BIN=$TF_BIN PROJECT=$PROJECT deploy
curl -s localhost

echo "# deploy and switch to green"
export TF_VAR_color=green ;
make TF_BIN=$TF_BIN PROJECT=$PROJECT deploy
curl -s localhost

echo "# deploy and switch to blue"
unset TF_VAR_color ;
make TF_BIN=$TF_BIN PROJECT=$PROJECT deploy
curl -s localhost

echo "# deploy and switch to blue"
export TF_VAR_blue_api_count=2
make TF_BIN=$TF_BIN PROJECT=$PROJECT deploy
curl -s localhost
curl -s localhost

echo "# destroy"
make TF_BIN=$TF_BIN PROJECT=$PROJECT destroy

#!/bin/bash

echo "# build docker cli/terraform $TERRAFORM_VERSION"
make build

TERRAFORM_VERSION=0.14.5
echo "# install terraform $TERRAFORM_VERSION"
mkdir -p bin
curl -s -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d bin/ \
    && rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

export TF_BIN=bin/terraform
export PROJECT=terraform/app-docker
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

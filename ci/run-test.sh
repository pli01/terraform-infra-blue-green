#!/bin/bash
set -e

#
# test http app
#
function test_app {
  echo "# Test ${1} up"
  set +e
  ret=0
  timeout=120;
  test_result=1
  until [ "$timeout" -le 0 -o "$test_result" -eq "0" ] ; do
      curl -s --fail --retry-max-time 120 --retry-delay 1  --retry 1  http://localhost:80
      test_result=$?
      echo "Wait $timeout seconds: APP coming up ($test_result)";
      (( timeout-- ))
      sleep 1
  done
  if [ "$test_result" -gt "0" ] ; then
       ret=$test_result
       echo "ERROR: APP down"
       return $ret
  fi

  return $ret
}

export TF_BIN=bin/terraform
export PROJECT=terraform-examples/app-docker
export TF_IN_AUTOMATION=true
TERRAFORM_VERSION=0.14.5
echo "# build docker cli/terraform $TERRAFORM_VERSION"
make build
make tf-version

echo "# docker cli/terraform : $PROJECT: deploy default (blue)"
make  PROJECT=$PROJECT DC_TF_ENV=" -f docker-compose.app-docker.yml" deploy
test_app
make  PROJECT=$PROJECT DC_TF_ENV=" -f docker-compose.app-docker.yml" destroy

echo "# install local terraform cli $TERRAFORM_VERSION"
make install-cli TF_BIN_VERSION=$TERRAFORM_VERSION

echo "# $PROJECT: init"
make TF_BIN=$TF_BIN PROJECT=$PROJECT init

echo "# $PROJECT: deploy default (blue)"
make TF_BIN=$TF_BIN PROJECT=$PROJECT deploy
test_app

echo "# $PROJECT: deploy and switch to green"
export TF_VAR_color=green ;
make TF_BIN=$TF_BIN PROJECT=$PROJECT deploy
test_app

echo "# $PROJECT: deploy and switch to blue"
unset TF_VAR_color ;
make TF_BIN=$TF_BIN PROJECT=$PROJECT deploy
test_app

echo "# $PROJECT: deploy and switch to blue"
export TF_VAR_blue_api_count=2
make TF_BIN=$TF_BIN PROJECT=$PROJECT deploy
test_app
test_app

echo "# $PROJECT: destroy"
make TF_BIN=$TF_BIN PROJECT=$PROJECT destroy

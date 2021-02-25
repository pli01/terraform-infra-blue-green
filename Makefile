SHELL = /bin/bash
TF_LOG := # debug
TF_BIN := $(shell type -p terraform)
TF_BIN_VERSION :=

TF_VAR_FILE := # -var-file=$(pwd)/config.auto.tfvars
TF_IN_AUTOMATION := # true
TF_CLI_ARGS_init :=
TF_CLI_ARGS_validate := 
TF_CLI_ARGS_plan    := ${TF_VAR_FILE}
TF_CLI_ARGS_apply   := ${TF_VAR_FILE} -auto-approve
TF_CLI_ARGS_destroy := ${TF_VAR_FILE} -auto-approve

DC       := $(shell type -p docker-compose)
DC_BUILD_ARGS := --pull --no-cache --force-rm
DC_TF_DOCKER_CLI := docker-compose.yml
export

check-var-%:
	@: $(if $(value $*),,$(error $* is undefined))

all:
	@echo "Usage: make PROJECT='myapp' build | deploy | destroy"
#
# terraform build ci tool
#
build:
	${DC} -f ${DC_TF_DOCKER_CLI} build ${DC_BUILD_ARGS}
install-cli:
	@scripts/install-terraform.sh ${TF_BIN_VERSION}

tf-version:
	${DC} -f ${DC_TF_DOCKER_CLI} run --rm terraform -c 'terraform version'
tf-validate:| check-var-PROJECT
	${DC} -f ${DC_TF_DOCKER_CLI} run --rm terraform -c 'terraform validate ${PROJECT}'

tf-%:| check-var-PROJECT
	${DC} -f ${DC_TF_DOCKER_CLI} run --rm terraform -c 'make PROJECT=${PROJECT} $*'

#
# terraform deploy
#
deploy: validate plan apply

init:| check-var-PROJECT
	${TF_BIN} -chdir=${PROJECT} init
format:| check-var-PROJECT
	${TF_BIN} -chdir=${PROJECT} fmt -check || ${TF_BIN} -chdir=${PROJECT} fmt -diff
validate:| check-var-PROJECT
	${TF_BIN} -chdir=${PROJECT} validate
plan:| check-var-PROJECT
	${TF_BIN} -chdir=${PROJECT} plan
apply:| check-var-PROJECT
	${TF_BIN} -chdir=${PROJECT} apply
destroy:| check-var-PROJECT
	${TF_BIN} -chdir=${PROJECT} destroy

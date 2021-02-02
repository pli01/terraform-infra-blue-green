SHELL = /bin/bash
TF_LOG := # debug
TF_BIN := $(shell type -p terraform)
TF_IN_AUTOMATION := # true
TF_CLI_ARGS_init :=
TF_CLI_ARGS_validate := 
TF_CLI_ARGS_plan    := 
TF_CLI_ARGS_apply   := -auto-approve
TF_CLI_ARGS_destroy := -auto-approve

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

tf-validate:| check-var-PROJECT
	${DC} -f ${DC_TF_DOCKER_CLI} run --rm terraform -c 'terraform validate ${PROJECT}'

tf-%:| check-var-PROJECT
	${DC} -f ${DC_TF_DOCKER_CLI} run --rm terraform -c 'make PROJECT=${PROJECT} $*'

#
# terraform deploy
#
deploy: validate plan apply

init:| check-var-PROJECT
	${TF_BIN} init ${PROJECT}
format:| check-var-PROJECT
	${TF_BIN} fmt -check ${PROJECT} || ${TF_BIN} fmt -diff ${PROJECT}
validate:| check-var-PROJECT
	${TF_BIN} validate ${PROJECT}
plan:| check-var-PROJECT
	${TF_BIN} plan ${PROJECT}
apply:| check-var-PROJECT
	${TF_BIN} apply ${PROJECT}
destroy:| check-var-PROJECT
	${TF_BIN} destroy ${PROJECT}

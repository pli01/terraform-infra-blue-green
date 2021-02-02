# terraform-infra-blue-green
Some examples on how to implement blue green with different stack and provider (docker, openstack)

* app-docker: sample app, with one web nginx as reverseproxy/lb and blue/green api stack in backend
* TODO: app-openstack

## Content of this repo

* terraform dir:
  + [terraform/app-docker](terraform/app-docker): web nginx as lb and blue green api
* Makefile: to launch terraform cli with options and vars

* terraform cli in docker image: everything we need in one place, no matter who s running it or where. Useful for CI/CD
  + Dockerfile
    + install default deb packages (python, jq, openstack-client)
    + install pip modules
    + install terraform cli in /usr/local/bin
    + install versioned terraform plugins from providers.tf in /usr/local/share/terraform/plugins



## app-docker example

This example is described in [terraform/app-docker](terraform/app-docker) and will deploy the following components
* web: nginx container working as reverse proxy and lb (upstream backend to color blue or green api)
* blue-api, green-api: python container, listen on http 9000 port and reply, "hello "color", from container 'hostname'"

![app-docker blue/green](docs/tf-infra-blue-green-app-docker.png)

You can deploy and choose:
* the blue or green color api. The web nginx reverseproxy will be connected to the one you choose
* deploy 1 or N container in the blue or green stack (blue-api-1, blue-api-2...)
* choose the blue or green image (ex: blue = python:2, green = python:3, or blue = myapp:v1, green = myapp:v2 etc)
* you will find a terraform module ([terraform/app-docker/modules/api](terraform/app-docker/modules/api) which create lightweight abstractions of docker resources with parameters (color, count, image, param) to deploy the api stack

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| color | color stack to deploy (`blue` or `green`) | string | `blue` | no |
| web_port | Web external port | number | 80 | no |
| api_port | API internal port | number | 9000 | no |
| web_count | Web container count | number | 1 | no |
| blue_api_count | Blue API container count  | number | 1 | no |
| green_api_count | Green API container count | number | 1 | no |
| blue_api_image | Blue API docker image name | string | `python:3` | no |
| green_api_image | Green API docker image name | string | `python:3` | no |

### Outputs

| Name | Description |
|------|-------------|
| color | deployed stack (blue | green) |
| web_ip | web ip list |
| wep_port |  web port list |
| blue_api_name | Blue API containers name list |
| green_api_name | Green API containers name list |
| blue_api_ip | Blue API containers ip list |
| green_api_ip | Green API containers ip list |

## Usage:

* build: build cli/terraform image with downloaded providers. This image can be use offline
```
  make build
```

* format: check and format tf files
```
  make PROJECT=terraform/app-docker TF_BIN=./terraform_0.14.5 format
```
* init: init state (providers,modules,backend)
```
  make PROJECT=terraform/app-docker init
```
* deploy: deploy app-project . It play (validate, plan, apply)
```
  make PROJECT=terraform/app-docker  deploy
```
* deploy with alternative terraform binary
```
  make PROJECT=terraform/app-docker TF_BIN=./terraform_0.14.5 deploy
```
* destroy: destroy app-project
```
  make PROJECT=terraform/app-docker destroy
```

## Test it
* First run
```
# make PROJECT=terraform/app-docker init
```
* Deploy default blue (1 blue-api)
```
# make PROJECT=terraform/app-docker deploy
# curl localhost
Hello, blue from e648210be937
```
* Deploy green (1 green-api)
```
# export TF_VAR_color=green ;
# make PROJECT=terraform/app-docker deploy
# curl localhost
Hello, green from fd2baa4f4758
```
* Deploy blue 
```
# unset TF_VAR_color ;
# make PROJECT=terraform/app-docker deploy
# curl localhost
Hello, blue from e648210be937
```
* Deploy 2 blue container
```
# export TF_VAR_blue_api_count=2
# make PROJECT=terraform/app-docker deploy
# curl localhost
Hello, blue from e648210be937
# curl localhost
Hello, blue from afd2315a1eec
```

## TODO:
* environment files
* use docker cli
* add wrapper to detect current color from previous output and change (if blue, then green)

# Tips
* TODO: add to Makefile/docker
```bash
# deploy test env
#  need terraform-examples/env/test.tfvars file
#
TF_VAR_env="test" ./scripts/terragrunt.sh terraform-examples/env destroy
```
```bash
# debug
TERRAGRUNT_LOG="debug" TF_LOG="" TF_VAR_env="test" ./scripts/terragrunt.sh terraform-examples/env plan
```

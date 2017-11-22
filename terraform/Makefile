.ONESHELL:
.PHONY: plan plan-debug apply apply-debug destroy

export START_TIME = $(shell date "+%s")
export TF_VAR_tenant_name = ${OS_TENANT_NAME}
export TF_VAR_domain = ${DOMAIN}
export TF_VAR_zone_id = $(shell openstack zone list -f value -c id)

# https://stackoverflow.com/a/10858332
# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Params:
#   1. Variable name(s) to test.
#   2. (optional) Error message to print.
_check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

plan:
	@:$(call _check_defined, GIT_REPO, variable GIT_REPO not set)
	@:$(call _check_defined, DOMAIN, variable DOMAIN not set)
	@terraform plan -var "git_repo=${GIT_REPO}"

plan-debug:
	@:$(call _check_defined, GIT_REPO, variable GIT_REPO not set)
	@:$(call _check_defined, DOMAIN, variable DOMAIN not set)
	@TF_LOG=DEBUG OS_DEBUG=1 terraform plan -var "git_repo=${GIT_REPO}"

apply:
	@:$(call _check_defined, GIT_REPO, variable GIT_REPO not set)
	@:$(call _check_defined, DOMAIN, variable DOMAIN not set)
	@terraform apply -var "git_repo=${GIT_REPO}"
	@scripts/check_up.sh

apply-debug:
	@:$(call _check_defined, GIT_REPO, variable GIT_REPO not set)
	@:$(call _check_defined, DOMAIN, variable DOMAIN not set)
	@TF_LOG=DEBUG OS_DEBUG=1 terraform apply -var "git_repo=${GIT_REPO}"
	@scripts/check_up.sh

destroy:
	@terraform destroy -var "git_repo=na" -force

destroy-debug:
	@TF_LOG=DEBUG OS_DEBUG=1 terraform destroy -var "git_repo=na" -force

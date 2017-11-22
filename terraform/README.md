# Elasticsearch as a Service Development

## Introduction
This repository manages the infrastructure to deploy ESaaS in your Openstack dev environment. The infrastructure is managed by Terraform and during an apply we setup CNAME records in Designate to point all exposed domains to fabio001.${var.domain} using a Makefile.

The default infrastructure will consist of the following nodes:
 * saltmaster x 1
 * nomad (server) x 1
 * nomad workers (clients) x 3
 * consul (server) x 1
 * fabio (lb) x 1

Once the environment is deployed, Saltstack takes care of configuring the nodes. It does this by getting the role, environment, (optionally) cluster and git\_repo from Openstack Metadata. Saltstack runs the configured Nomad jobs to provide a "one-click" experience to users of this repository.

Right after the terraform plan the Makefile calls `scripts/check_up.sh` to keep probing if the HashiUI is up. Once that is up and you have Google Chrome installed on your local (OSX) workstation, it'll open up a set of configured sites. It is likely that HashiUI is up sooner than Kibana/Elastic. Be patient as it can take a bit longer before the Elasticsearch cluster is fully up. This is due to the fact that docker images need to be pulled on the Nomad workers.

Once Kibana is up you can login with default credentials:  
**user**: elastic  
**pass**: changeme

## Prerequisites
1. have openstack + designate client installed locally `pip install python-openstackclient python-designateclient`
2. if you don't have Terraform yet, install it and make sure it's available in your $PATH (use either homebrew or direct download https://www.terraform.io/downloads.html)
3. set the correct environment variables for OpenStack in your shell
4. configure `vars.tf` appropriately

## Example terraform runs
Before doing anything you should pull all Terraform modules by executing:
```
terraform get
```

Run Terraform plan:
```
make GIT_REPO="git@github.com:${USER}/salt.git" plan
```

Run Terraform plan with DEBUG enabled:
```
make GIT_REPO="git@github.com:${USER}/salt.git" plan-debug
```

Run Terraform apply:
```
make GIT_REPO="git@github.com:${USER}/salt.git" apply
```

Run Terraform apply with DEBUG enabled:
```
make GIT_REPO="git@github.com:${USER}/salt.git" apply-debug
```

Run Terraform destroy:
```
make destroy
```

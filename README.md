# marcelocorreia/terraform

Docker image with [Hashicorp Terraform](https://www.terraform.io) + [AWS CLI](https://aws.amazon.com/cli/)

## INFO
- Workdir is set to /opt/workspace
- Github: [https://github.com/marcelocorreia/docker-terraform](https://github.com/marcelocorreia/docker-terraform)
- [Integration](#) with [Concourse CI](http://concourse.ci/) 
 
## Usage
```bash
$> docker run --rm -v $(shell pwd):/opt/workspace \
   		marcelocorreia/terraform \
   		terraform [--version] [--help] <command> [args]
```



## Example
```bash
$> docker run --rm -v $(shell pwd):/opt/workspace \
   		marcelocorreia/terraform \
   		terraform $1 -var-file variables.tfvars \
   		-var aws_access_key=${aws_access_key_id} \
   		-var aws_secret_key=${aws_secret_access_key}
```

## Makefile example
```makefile
# VARS
TF_IMAGE?=marcelocorreia/terraform:latest
VARS_FILE?=variables.tfvars

# TF
tf-plan:
	$(call terraform, plan)
.PHONY: tf-plan

tf-apply:
	$(call terraform, apply)
.PHONY: tf-apply

tf-destroy:
	$(call terraform, destroy)
.PHONY: tf-destroy

tf-refresh:
	$(call terraform, refresh)
.PHONY: tf-refresh

tf-show:
	$(call terraform, show)
.PHONY: tf-show

tf-shell:
	@docker run --rm -it -v $(shell pwd):/opt/workspace \
    		$(TF_IMAGE)\
    		bash
.PHONY: tf-shell

tf-state-list:
	$(call terraform, state list)
.PHONY: tf-show

# DOCKER
tf-image-update:
	docker pull $(TF_IMAGE)
.PHONY: tf-image-update

# ROUTINES
define terraform
	@docker run --rm -v $(shell pwd):/opt/workspace \
		$(TF_IMAGE)\
		terraform $1 -var-file $(VARS_FILE) \
		-var aws_access_key=${aws_access_key_id} \
		-var aws_secret_key=${aws_secret_access_key}
endef

```

### [Check the Concourse CI Pipeline used to build this image](https://github.com/marcelocorreia/docker-terraform/blob/master/pipeline.yml) 

#### Concourse Build Configuration Example

```yaml
platform: linux

image_resource:
  type: docker-image
  source:
    repository: marcelocorreia/terraform
    tag: 'latest'

inputs:
- name: terraform-repo

run:
  path: terraform
  args: [plan]
```


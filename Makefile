include terraform.mk

REPOSITORY=docker-terraform
CONTAINER=terraform
NAMESPACE=marcelocorreia
VERSION=0.9.4
PIPELINE_NAME=$(REPOSITORY)-release
CI_TARGET=dev
build:
	docker build -t $(NAMESPACE)/$(CONTAINER):latest .
.PHONY: build

set-pipeline:
	fly -t $(CI_TARGET) set-pipeline \
		-n -p $(PIPELINE_NAME) \
		-c pipeline.yml \
		-l $(HOME)/.ssh/ci-credentials.yml \
		-v git_repo_url=git@github.com:$(NAMESPACE)/$(REPOSITORY).git \
        -v container_fullname=$(NAMESPACE)/$(CONTAINER) \
        -v container_name=$(CONTAINER) \
		-v git_repo=$(REPOSITORY) \
        -v git_branch=master \
        -v release_version=$(VERSION)

	fly -t $(CI_TARGET) unpause-pipeline -p $(PIPELINE_NAME)
	fly -t $(CI_TARGET) trigger-job -j $(PIPELINE_NAME)/$(PIPELINE_NAME)
	fly -t $(CI_TARGET) watch -j $(PIPELINE_NAME)/$(PIPELINE_NAME)
.PHONY: set-pipeline


watch-pipeline:
	fly -t $(CI_TARGET) watch -j $(PIPELINE_NAME)/$(PIPELINE_NAME)
.PHONY: watch-pipeline

destroy-pipeline:
	fly -t $(CI_TARGET) destroy-pipeline -p $(PIPELINE_NAME)
.PHONY: destroy-pipeline

docs:
	grip -b





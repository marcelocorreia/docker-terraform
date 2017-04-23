include terraform.mk

REPOSITORY=docker-terraform
CONTAINER=terraform
NAMESPACE=marcelocorreia
VERSION=0.9.3

set-pipeline:
	fly -t main set-pipeline \
		-n -p $(CONTAINER) \
		-c pipeline.yml \
		-l /home/marcelo/.ssh/ci-credentials.yml \
		-v git_repo_url=git@github.com:$(NAMESPACE)/$(REPOSITORY).git \
        -v container_fullname=$(NAMESPACE)/$(CONTAINER) \
        -v container_name=$(CONTAINER) \
		-v git_repo=$(REPOSITORY) \
        -v git_branch=master \
        -v release_version=$(VERSION)

	fly -t main unpause-pipeline -p $(CONTAINER)
.PHONY: set-pipeline

destroy-pipeline:
	fly -t main destroy-pipeline \
	-p $(CONTAINER)

build:
	docker build -t $(NAMESPACE)/$(CONTAINER) .
.PHONY: build



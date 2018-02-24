include terraform.mk
-include localdev.mk

REPOSITORY := docker-terraform
CONTAINER := terraform
NAMESPACE := marcelocorreia
VERSION := $(shell cat version)
PIPELINE_NAME := $(REPOSITORY)-release
FLY_TARGET := dev
ALPINE_VERSION := 3.7

GITHUB_USER := hashicorp

ifdef GITHUB_TOKEN
TOKEN_FLAG := -H "Authorization: token $(GITHUB_TOKEN)"
endif

get-last-release:
	@OUT=$(shell curl -s $(TOKEN_FLAG) https://api.github.com/repos/$(GITHUB_USER)/$(CONTAINER)/tags | jq ".[]|.name" | head -n1 | sed 's/\"//g' | sed 's/v*//g') && \
	echo $${OUT}

check-new-version:
	@LAST=$(shell make get-last-release) && \
	 if [ $(VERSION) != $$LAST ];then \
	 	printf "Updating $(CONTAINER) :: $(VERSION) -> $$LAST"; \
		echo "$$LAST" > version; \
		$(MAKE) update-version; \
	else \
	 	printf "Container $(CONTAINER) already up to date - Version: $(VERSION)"; \
	fi


pipeline-login:
	fly -t $(FLY_TARGET) login -n $(FLY_TARGET) -c https://ci.correia.io

update-version:
	@cat Dockerfile | \
	 	sed  's/ARG tf_version=".*"/ARG tf_version="$(VERSION)"/' | \
	 	sed  's/^FROM.*/FROM alpine:$(ALPINE_VERSION)/' \
	 		 > /tmp/Dockerfile.tmp

	@cat /tmp/Dockerfile.tmp > Dockerfile
	@rm /tmp/Dockerfile.tmp

build:
	docker build -t $(NAMESPACE)/$(CONTAINER):latest .
	docker build -t $(NAMESPACE)/$(CONTAINER):$(VERSION) .
.PHONY: build

git-push:
	git add .; git commit -m "Pipeline WIP"; git push

set-pipeline: git-push
	fly -t $(FLY_TARGET) set-pipeline \
		-n -p $(PIPELINE_NAME) \
		-c pipeline.yml \
		-l $(HOME)/.ssh/ci-credentials.yml \
		-v git_repo_url=git@github.com:$(NAMESPACE)/$(REPOSITORY).git \
        -v container_fullname=$(NAMESPACE)/$(CONTAINER) \
        -v container_name=$(CONTAINER) \
		-v git_repo=$(REPOSITORY) \
        -v git_branch=master \
        -v release_version=$(VERSION)

	fly -t $(FLY_TARGET) unpause-pipeline -p $(PIPELINE_NAME)

.PHONY: set-pipeline

trigger-job:
	fly -t $(FLY_TARGET) trigger-job -j $(PIPELINE_NAME)/$(PIPELINE_NAME)

watch-pipeline:
	fly -t $(FLY_TARGET) watch -j $(PIPELINE_NAME)/$(PIPELINE_NAME)
.PHONY: watch-pipeline

destroy-pipeline:
	fly -t $(FLY_TARGET) destroy-pipeline -p $(PIPELINE_NAME)2
.PHONY: destroy-pipeline

docs:
	grip -b





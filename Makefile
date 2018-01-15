# Makefile for Docker tasks
#
# Author: Karsten Kroesch <karsten.kroesch@swisscom.com>
# Original version by @mpneuried

# import config.
# You can change the default config with `make cnf="config_special.env" build`
cnf ?= config.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf)) 

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS

image: ## Build the container image
	docker build -t="$(APP_NAME)" --build-arg http_proxy=$(HTTP_PROXY) --build-arg https_proxy=$(HTTPS_PROXY) $(DOCKERFILE_DIR)

run: ## Run container on port configured in `config.env`
	docker run -i -t --rm --env-file=./config.env -p=$(LOCAL_PORT):$(CONTAINER_PORT) --name="$(APP_NAME)" $(CONTAINER_NAME)

daemon: ## Run container on port configured in `config.env`
	docker run -d --env-file=./config.env -p=$(LOCAL_PORT):$(CONTAINER_PORT) --name="$(APP_NAME)" $(CONTAINER_NAME)

shutdown: ## Stop and remove a running container
	docker stop $(APP_NAME); docker rm $(APP_NAME)

shell: ## Opens a shell in the container context
	docker exec -it $(APP_NAME) /bin/bash

clean: ## Remove container and image
	docker rm $(APP_NAME)
	docker rmi $(APP_NAME)

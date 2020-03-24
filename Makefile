# Use one shell for all commands in a target recipe
.ONESHELL:
.PHONY: setup data code results cleandata cleanresults listdata listresults run run-all
# Set default goal
.DEFAULT_GOAL := help
# Use bash shell in Make instead of sh
SHELL := /bin/bash
LOCAL_DATA_PATH := '../data'
LOCAL_CODE_PATH := '../code'
LOCAL_RESULTS_PATH := '../results'

lint: ## Run linter
	@tox -e lint

setup: ## Setup nodes for use
	@tox -e setup

data: ## Push data
	@tox -e playbook -- --tags=push --extra-vars "data_path=$(LOCAL_DATA_PATH)"

deps: ## Install dependencies
	@tox -e setup -- --tags=deps --extra-vars "code_path=$(LOCAL_CODE_PATH)"

code: ## Push code
	@tox -e playbook -- --tags=code --extra-vars "code_path=$(LOCAL_CODE_PATH)"

results: ## Pull results
	@tox -e playbook -- --tags=pull --extra-vars "results_path=$(LOCAL_RESULTS_PATH)"

clean: ## Clean results remote
	@tox -e playbook -- --tags=cleanresults

list: ## List results remote
	@tox -e playbook -- --tags=listresults

cleandata: ## Clean data remote
	@tox -e playbook -- --tags=cleandata

listdata: ## List data remote
	@tox -e playbook -- --tags=listdata

run: ## Run tasks.txt or default.tasks.txt
	@ssh-add scibox/files/$$(whoami)-ssh-key >/dev/null 2>&1
	@cat tasks.txt 2>/dev/null || cat default.tasks.txt | parallel --ungroup --no-run-if-empty --sshloginfile hosts.txt --workdir "/home/ubuntu/scibox"

run-all: data run results cleanresults

# Display target comments in 'make help'
help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

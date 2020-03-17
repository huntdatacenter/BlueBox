# Use one shell for all commands in a target recipe
.ONESHELL:
.PHONY: data code results cleandata cleanresults listdata listresults
# Set default goal
.DEFAULT_GOAL := help
# Use bash shell in Make instead of sh
SHELL := /bin/bash
LOCAL_DATA_PATH := './data'
LOCAL_CODE_PATH := './code'
LOCAL_RESULTS_PATH := './results'

lint: ## Run linter
	@tox -e lint

data: ## Push data
	@tox -e data --extra-vars "data_path=$(LOCAL_DATA_PATH)"

code: ## Push code
	@tox -e code --extra-vars "code_path=$(LOCAL_CODE_PATH)"

results: ## Pull results
	@tox -e pull --extra-vars "results_path=$(LOCAL_RESULTS_PATH)"

cleandata: ## Clean data remote
	ansible-playbook playbook.yaml -t cleandata

cleanresults: ## Clean results remote
	ansible-playbook playbook.yaml -t cleanresults

listdata: ## List data remote
	ansible-playbook playbook.yaml -t listdata

listresults: ## List results remote
	ansible-playbook playbook.yaml -t listresults

run: ## Run tasks.txt
	cat tasks.txt | parallel -j1 --ungroup --sshloginfile hosts.txt --no-run-if-empty --workdir /home/ubuntu/code

run-all: data run results cleanresults

# Display target comments in 'make help'
help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

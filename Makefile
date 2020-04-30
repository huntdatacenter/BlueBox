# Use one shell for all commands in a target recipe
.ONESHELL:
.PHONY: setup data code results cleandata cleanresults listdata listresults run run-all retry resume watch
# Set default goal
.DEFAULT_GOAL := help
# Use bash shell in Make instead of sh
SHELL := /bin/bash
LOCAL_DATA_PATH ?= '../data'
LOCAL_CODE_PATH ?= '../code'
LOCAL_RESULTS_PATH ?= '../results'
USER ?= $$(whoami)
tasks := tasks.txt
hosts := hosts.txt
params := --ungroup --no-run-if-empty --filter-hosts
log := task.log

lint: ## Run linter
	@tox -e lint

setup: ## Setup nodes for use
	@tox -e setup -- --extra-vars "hosts_path=$(hosts)"

data: ## Push data
	@tox -e playbook -- --tags=push --extra-vars "data_path=$(LOCAL_DATA_PATH)" --extra-vars "hosts_path=$(hosts)"

deps: ## Install dependencies
	@tox -e setup -- --tags=deps --extra-vars "code_path=$(LOCAL_CODE_PATH)" --extra-vars "hosts_path=$(hosts)"

code: ## Push code
	@tox -e playbook -- --tags=code --extra-vars "code_path=$(LOCAL_CODE_PATH)" --extra-vars "hosts_path=$(hosts)"

results: ## Pull results
	@tox -e playbook -- --tags=pull --extra-vars "results_path=$(LOCAL_RESULTS_PATH)" --extra-vars "hosts_path=$(hosts)"

clean: ## Clean results remote
	@tox -e playbook -- --tags=cleanresults --extra-vars "hosts_path=$(hosts)"

list: ## List results remote
	@tox -e playbook -- --tags=listresults --extra-vars "hosts_path=$(hosts)"

cleandata: ## Clean data remote
	@tox -e playbook -- --tags=cleandata -vv --extra-vars "hosts_path=$(hosts)"

listdata: ## List data remote
	@tox -e playbook -- --tags=listdata --extra-vars "hosts_path=$(hosts)"

run: ## Run tasks.txt or example.tasks.txt
	@echo "Run: $(tasks)"
	@eval $$(ssh-agent -s) >/dev/null 2>&1
	@ssh-add bluebox/files/$$(whoami)-ssh-key >/dev/null 2>&1
	@parallel $(params) --joblog $(log) --sshloginfile "$(hosts)" --workdir "/home/ubuntu/bluebox" :::: "$(tasks)"

run-all: clean code data run results

retry: params += --retry-failed
retry: params += --retries 3
retry: run

resume: params += --resume
resume: run

ssh:
	@ssh -i bluebox/files/$(USER)-ssh-key ubuntu@$(host)

watch:
	@watch -c -n 3 "pssh -h \"$(hosts)\" -x \"-i bluebox/files/$$(whoami)-ssh-key\" -P 'S_COLORS=always blueboxmon' | sed -E 's/^([0-9.]+):/\1:\n/g' | grep -v SUCCESS"

# Display target comments in 'make help'
help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

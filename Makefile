#!make

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; \
		{printf "%-14s %s\n", $$1, $$2}' | \
		sort

all-check: fmt-check lint-check readme typos tests ## Run all checks

docker-ci: | dependencies fmt-check lint-check typos symlink tests ## Run docker ci

dependencies: ## Install dependencies
	@./dev/dependencies

fmt: ## Format bash code
	@fd . -t f dev scripts tests --absolute-path | xargs shfmt -i 2 -w

fmt-check: ## Check format bash code
	@fd . -t f dev scripts tests --absolute-path | xargs shfmt -i 2 -d

readme: ## Write README.md
	@./dev/readme

lint-check: ## Check lint bash code
	@fd . -t f dev scripts tests --absolute-path | rg assert -v | xargs shellcheck -o all

symlink: ## Add symlink to scripts in path
	@./dev/symlink

unsymlink: ## Remove symlink to scripts from path
	@./dev/unsymlink

tests: ## Tests utilities
	@fd test- tests | xargs -n1 bash

typos: ## Check typos
	@typos

typos-fix: ## Fix typos
	@typos -w

.PHONY: help
.PHONY: all-check
.PHONY: ci
.PHONY: dependencies
.PHONY: fmt
.PHONY: fmt-check
.PHONY: readme
.PHONY: lint-check
.PHONY: symlink
.PHONY: unsymlink
.PHONY: tests
.PHONY: typos
.PHONY: typos-fix

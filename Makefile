#!make

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; \
		{printf "%-14s %s\n", $$1, $$2}' | \
		sort

dependencies: ## Install dependencies
	@./dev/dependencies.sh

fmt: ## Format bash code
	@fd . -e sh --absolute-path | xargs shfmt -i 4 -w

fmt-check: ## Check format bash code
	@fd . -e sh --absolute-path | xargs shfmt -i 4 -d

readme: ## Write README.md
	@./dev/readme.sh

symlink: ## Add symlink to scripts in path
	@./dev/symlink.sh

unsymlink: ## Remove symlink to scripts from path
	@./dev/unsymlink.sh

tests: ## Tests utilities
	@fd test- -e sh tests | xargs -n1 bash

typos: ## Check typos
	@typos

typos-fix: ## Fix typos
	@typos -w

.PHONY: help
.PHONY: dependencies
.PHONY: fmt
.PHONY: fmt-check
.PHONY: readme
.PHONY: symlink
.PHONY: unsymlink
.PHONY: tests
.PHONY: typos
.PHONY: typos-fix

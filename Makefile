#!make

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; \
		{printf "%-14s %s\n", $$1, $$2}' | \
		sort

fmt: ## Format bash code
	@fd . -e sh --absolute-path | xargs shfmt -i 4 -w

readme: ## Write README.md
	@./dev/readme.sh

symlink: ## Add symlink to scripts in path
	@sudo ln -s -f $(shell pwd)/scripts/git-bump.sh /usr/local/bin/git-bump

typos: ## Show typos
	@typos

typos-fix: ## Fix typos
	@typos -w

.PHONY: help
.PHONY: fmt
.PHONY: readme
.PHONY: symlink
.PHONY: typos
.PHONY: typos-fix

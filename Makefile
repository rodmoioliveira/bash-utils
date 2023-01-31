#!make

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; \
		{printf "\033[36m%-14s\033[0m %s\n", $$1, $$2}' | \
		sort

fmt: ## Format bash code
	@fd . -e sh --absolute-path | xargs shfmt -i 4 -w

typos: ## Show typos
	@typos

typos-fix: ## Fix typos
	@typos -w

.PHONY: help
.PHONY: fmt
.PHONY: typos
.PHONY: typos-fix

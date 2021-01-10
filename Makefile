#!/usr/bin/make

SHELL := /bin/bash
GITCLOUD_DEVOPS_PATH := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
GITCLOUD_DEVOPS_NAME ?= "Gitcloud DevOps"
GITCLOUD_DEVOPS_VERSION ?= "0.1.0"
GITCLOUD_DEVOPS_DESCRIPTION ?= "Images and Containers for Gitcloud Services."

ENV := local
-include config/.env.${ENV}
-include config/secrets/.env.${ENV}

.DEFAULT_GOAL := help-devops
.PHONY: help-devops #: List available command.
help: help-devops # alias for quick access
help-devops:
	@cd ${GITCLOUD_DEVOPS_PATH} && awk 'BEGIN {FS = " ?#?: "; print ""${GITCLOUD_DEVOPS_NAME}" "${GITCLOUD_DEVOPS_VERSION}"\n"${GITCLOUD_DEVOPS_DESCRIPTION}"\n\nUsage: make \033[36m<command>\033[0m\n\nCommands:"} /^.PHONY: ?[a-zA-Z_-]/ { printf "  \033[36m%-10s\033[0m %s\n", $$2, $$3 }' $(MAKEFILE_LIST)

.PHONY: docs-devops #: Serve documentation.
docs: docs-devops # alias for quick access
docs-devops:
	@false

.PHONY: lint-devops #: Run static code analysis.
lint: lint-devops # alias for quick access
lint-devops:
	@false

.PHONY: test-devops #: Run tests.
test: test-devops
test-devops:
	@false

.PHONY: build-devops #: Build images.
build: build-devops # alias for quick access
build-devops:
	@false

.PHONY: run-devops #: Run examples.
run: run-devops # alias for quick access
run-devops:
	@false

# Run scripts using make
%-script:
	@cd ${GITCLOUD_DEVOPS_PATH} && \
	if [[ -f "scripts/${*}.sh" ]]; then \
	${SHELL} "scripts/${*}.sh"; fi

.PHONY: init-devops #: Login and pull images.
init: init-devops # alias for quick access
init-devops:
	@false

.PHONY: release-devops #: Release and push docker images
release: release-devops # alias for quick access
release-devops:
	@false

.PHONY: package-devops #: Package Helm Charts
package: package-devops # alias for quick access
package-devops:
	@false

.PHONY: deploy-devops #: Deploy to Heroku.
deploy: deploy-devops # alias for quick access
deploy-devops:
	@false

.PHONY: clean-devops #: 
clean: clean-devops # alias for quick access
clean-devops:
	@false

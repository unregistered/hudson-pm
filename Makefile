SHELL := /bin/bash
SCRIPTS := $(wildcard scripts/*.sh)

.PHONY: check monitor notify

## Lint all bash scripts with shellcheck and bash -n
check:
	@echo "==> shellcheck"
	shellcheck $(SCRIPTS)
	@echo "==> bash -n (syntax check)"
	@for f in $(SCRIPTS); do bash -n "$$f" && echo "  $$f OK"; done
	@echo "All checks passed."

## Run the monitoring loop (default: last 15 minutes)
monitor:
	bash scripts/monitor.sh $(or $(MINUTES),15)

## Send a quick Pushover notification
## Usage: make notify TITLE="Test" MSG="Hello"
notify:
	bash scripts/send-pushover.sh --title "$(TITLE)" --message "$(MSG)"

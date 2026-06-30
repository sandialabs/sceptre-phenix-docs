SHELL=/bin/bash
DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "Available targets:"
	@echo ""
	@echo "Development:"
	@echo "  serve        - Build and serve the documentation locally"
	@echo "  lint         - Run all prek hooks across the whole repository"
	@echo "  install-dev  - Install local dev tooling (prek) and register git hooks"
	@echo ""
	@echo "Cleanup:"
	@echo "  clean        - Remove the local documentation builder image"
	@echo ""
	@echo "Help:"
	@echo "  help         - Show this help message"

.PHONY: serve
serve:
	./mkdocs-helper.sh

.PHONY: lint
lint:
	@command -v prek > /dev/null || { echo "Error: 'prek' not found. Run 'make install-dev' first."; exit 1; }
	prek run --all-files

.PHONY: install-dev
install-dev:
	@command -v prek > /dev/null || pip install 'prek>=0.4.3'
	prek install

.PHONY: clean
clean:
	docker rmi sceptre-phenix-docs-builder || true

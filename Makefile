.PHONY: serve-docs
serve-docs:
	docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material

.PHONY: build-docs
build-docs:
	docker run --rm -it -v ${PWD}:/docs squidfunk/mkdocs-material build

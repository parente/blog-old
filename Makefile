.PHONY: build clean env help release server

GIT_VERSION := $(shell git describe --abbrev=4 --dirty --always --tags)

export SITE_DOMAIN:=parente.dev

help:
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z0-9_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo
	@echo Note: Changes to master trigger travis pushes to gh-pages


clean: ## Make a clean workspace
	@rm -rf _output
	@git clean -f .

env: ## Make the current python environment install the generator prereqs
	@pip install -r requirements.txt

build: ## Make a local copy of the blog
	python generate.py

release: build ## Make a manual deployment of the blog
	@cd _output && \
		git init && \
		git remote add upstream 'git@github.com:parente/blog.git' && \
		git fetch --depth=1 upstream gh-pages && \
		git reset upstream/gh-pages && \
		echo "$(SITE_DOMAIN)" > CNAME && \
		git add -A . && \
		git commit -m "Release $(GIT_VERSION)" && \
		git push upstream HEAD:gh-pages

server: ## Make a local web server point to the latest local build
	@open http://localhost:8000/_output && python -m http.server
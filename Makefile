.PHONY: build clean dev env help release

GIT_VERSION := $(shell git describe --abbrev=4 --dirty --always --tags)

IMAGE:=parente/blog:latest

export SITE_AUTHOR:=Peter Parente
export SITE_NAME:=Parente's Mindtrove
export SITE_DOMAIN:=mindtrove.info

help:
	@echo '1. Setup - make env'
	@echo '2. Render - make build'
	@echo '3. Inspect - make server'
	@echo '4. Release - make release'

clean:
	@rm -rf _output

env:
	@conda create -n blog --file requirements.txt python=3

build:
	python generate.py

release: build
	@cd _output && \
		git init && \
		git remote add upstream 'git@github.com:parente/blog.git' && \
		git fetch --depth=1 upstream gh-pages && \
		git reset upstream/gh-pages && \
		echo "$(SITE_DOMAIN)" > CNAME && \
		git add -A . && \
		git commit -m "Release $(GIT_VERSION)" && \
		git push upstream HEAD:gh-pages

server:
	@open http://localhost:8000/_output && python -m http.server
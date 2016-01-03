.PHONY: build clean dev env help release

GIT_VERSION := $(shell git describe --abbrev=4 --dirty --always --tags)

IMAGE:=parente/blog:latest

SITE_AUTHOR:=Peter Parente
SITE_NAME:=Parente's Mindtrove
SITE_DOMAIN:=mindtrove.info

help:
	@echo 'make clean release'

clean:
	@rm -rf _output

env:
	@docker build --rm -t $(IMAGE) .

build:
	@docker run -it --rm \
		-e SITE_AUTHOR='$(SITE_AUTHOR)' \
		-e SITE_NAME="$(SITE_NAME)" \
		-e SITE_DOMAIN='http://$(SITE_DOMAIN)' \
		-v `pwd`:/srv/blog \
		$(IMAGE) python generate.py

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

dev:
	@docker run -it --rm  \
		-e SITE_AUTHOR='$(SITE_AUTHOR)' \
		-e SITE_NAME="$(SITE_NAME)" \
		-e SITE_DOMAIN='http://$(SITE_DOMAIN)' \
		-v `pwd`:/srv/blog -p 8000:8000 $(IMAGE) /bin/bash
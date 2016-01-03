.PHONY: build clean dev env release

GIT_VERSION := $(shell git describe --abbrev=4 --dirty --always --tags)

IMAGE:=parente/blog:latest

SITE_AUTHOR:=Peter Parente
SITE_NAME:=Parente's Mindtrove
SITE_DOMAIN:=http://mindtrove.info

help:
	@cat Makefile

clean:
	@rm -rf _output

env:
	@docker build --rm -t $(IMAGE) .

build:
	@docker run -it --rm \
		-e SITE_AUTHOR='$(SITE_AUTHOR)' \
		-e SITE_NAME="$(SITE_NAME)" \
		-e SITE_DOMAIN='$(SITE_DOMAIN)' \
		-v `pwd`:/srv/blog \
		$(IMAGE) python generate.py

release: build
	@git checkout gh-pages
	@mv _output/* .
	@rm -r _output
	@git commit -m "Release $(GIT_VERSION)"

dev:
	@docker run -it --rm  \
		-e SITE_AUTHOR='$(SITE_AUTHOR)' \
		-e SITE_NAME="$(SITE_NAME)" \
		-e SITE_DOMAIN='$(SITE_DOMAIN)' \
		-v `pwd`:/srv/blog -p 8000:8000 $(IMAGE) /bin/bash
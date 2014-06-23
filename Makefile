.PHONY: build publish watch

help:
	@echo
	@echo 'targets: build, publish, watch'
	@echo 'e.g, SITE_ROOT=/~parente/blog make build'
	@echo

build:
	@python generate.py

publish:
	@python generate.py
	@rsync -avzL --delete _output/ mindtrove.info:webapps/blog/

watch:
	@wr "make build" pages templates static generate.py
.PHONY: build publish watch

build:
	@python generate.py

publish:
	@python generate.py
	@rsync -avzL --delete _output/ mindtrove.info:webapps/blog/

watch:
	@SITE_ROOT=/~parente/blog wr "make site" pages templates static generate.py
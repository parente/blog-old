.PHONY: site watch

site:
	@python generate.py

watch:
	@SITE_ROOT=/~parente/blog wr "make site" pages templates static generate.py
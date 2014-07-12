.PHONY: build publish watch render dev

REPO:=parente/blog
TAG?=latest
IMAGE=$(REPO):$(TAG)

help:
	@cat Makefile

build:
	@docker build --rm -t $(IMAGE) .

publish:
	@docker run -it --rm -v `pwd`:/srv/blog $(IMAGE) bash -c 'python generate.py; rsync -avzL --delete _output/ mindtrove.info:webapps/blog/'

watch:
	@docker run -it --rm -v `pwd`:/srv/blog $(IMAGE) watchmedo shell-command -W -R --command="python /srv/blog/generate.py" pages static templates

render:
	@docker run -it --rm -v `pwd`:/srv/blog -p 8000:8000 $(IMAGE) bash -c 'python generate.py; cd _output; python -m SimpleHTTPServer'

dev:
	@docker run -it --rm -v `pwd`:/srv/blog -p 8000:8000 $(IMAGE) /bin/bash
.PHONY: build publish watch render dev

REPO:=parente/blog
TAG:=latest
IMAGE:=$(REPO):$(TAG)

REMOTE_TARGET:=root@mindtrove.info:/srv/html/blog/
REMOTE_KEY:=$(HOME)/.ssh/do

SITE_AUTHOR:=Peter Parente
SITE_NAME:=Parente's Mindtrove
SITE_DOMAIN:=http://mindtrove.info

help:
	@cat Makefile

build:
	@docker build --rm -t $(IMAGE) .

publish:
	@docker run -it --rm \
		-e SITE_AUTHOR='$(SITE_AUTHOR)' \
		-e SITE_NAME="$(SITE_NAME)" \
		-e SITE_DOMAIN='$(SITE_DOMAIN)' \
		-v `pwd`:/srv/blog \
		$(IMAGE) bash -c 'python generate.py'
	@rsync -rltvz --delete -e "ssh -i $(REMOTE_KEY)" _output/ $(REMOTE_TARGET)

watch:
	@docker run -it --rm \
		-e SITE_AUTHOR='$(SITE_AUTHOR)' \
		-e SITE_NAME="$(SITE_NAME)" \
		-e SITE_DOMAIN='$(SITE_DOMAIN)' \
		-v `pwd`:/srv/blog \
		$(IMAGE) watchmedo shell-command -W -R --command="python /srv/blog/generate.py" pages static templates

render:
	docker run -it --rm \
		-e SITE_AUTHOR='$(SITE_AUTHOR)' \
		-e SITE_NAME="$(SITE_NAME)" \
		-e SITE_DOMAIN='$(SITE_DOMAIN)' \
		-v `pwd`:/srv/blog \
		-p 8000:8000 \
		$(IMAGE) bash -c 'python generate.py; cd _output; python -m SimpleHTTPServer'

dev:
	@docker run -it --rm  \
		-e SITE_AUTHOR='$(SITE_AUTHOR)' \
		-e SITE_NAME="$(SITE_NAME)" \
		-e SITE_DOMAIN='$(SITE_DOMAIN)' \
		-v `pwd`:/srv/blog -p 8000:8000 $(IMAGE) /bin/bash
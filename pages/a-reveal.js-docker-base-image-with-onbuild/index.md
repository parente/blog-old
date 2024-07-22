---
title: A reveal.js Docker Base Image with ONBUILD
date: 2014-02-20
---

Docker 0.8 introduced the `ONBUILD` instruction for Dockerfiles. I'll admit, when I read [the release announcement](http://blog.docker.io/2014/02/docker-0-8-quality-new-builder-features-btrfs-storage-osx-support/), I glossed right over this new feature. Now that I've had time to [read more about it](http://docs.docker.io/en/latest/reference/builder/#onbuild), I can see its potential for creating build environments.

Let me show you by containerizing reveal.js.

## The Base Image

[Reveal.js](http://lab.hakim.se/reveal-js/#/) bills itself as "a framework for easily creating beautiful presentations using HTML." Most reveal.js features work just fine when we load the presentation directly from the filesystem. But some features, like Markdown support, require that we load the presentation from a running web server. A Docker container can tie everything up in one tidy package that we can move and run anywhere.

We could write a Dockerfile that installs NodeJS, downloads reveal.js, installs its npm dependencies, and inserts our Markdown slides into the container on build. We could then copy and build this Dockerfile everywhere we want to develop or run a slideshow server. Or we could keep cramming new markdown files into a single container by rebuilding or `scp`ing them in a backdoor. Or we could build a generic image that, when run, requires us to volume mount our slides from the host or another container.

`ONBUILD` introduces a new possibility. With it, we can build a base image that completely configures reveal.js and the web server, but delays insertion of the actual slide content until a child Dockerfile build. The key snippet from the Dockerfile appears below:

```bash
FROM ubuntu:13.10
MAINTAINER Peter Parente <parente@cs.unc.edu>

# elided dependency setup, then ...

ONBUILD ADD slides.md /revealjs/md/

# elided final setup
```

We can build the base image once and store it in the Docker registry via `docker push`, or setup a trusted build. (I've [done the latter](https://index.docker.io/u/parente/revealjs/), which shows the full Dockerfile, if you're interested).

## The Slideshow Image

Later, when we have a new slideshow, we can put a one-line Dockerfile:

```bash
FROM parente/revealjs
```

in the same folder as our `slides.md`:

```markdown
# Docker + reveal.js

### A reveal.js Docker Base Image with ONBUILD

---

## Write more slides
```

and do a build:

```bash
$ docker build -t slideshow .
```

During this build, Docker executes the delayed `ONBUILD ADD slides.md /revealjs/md/` instruction. It pulls our local `slides.md` file into the child image. The result is a portable Docker image that can run our slideshow server anywhere Docker runs.

```bash
$ docker run -d -P slideshow
```

And of course all the standard `docker run` options still apply: a fixed port, container naming, running in the foreground, etc.

## A Development Story

The build and run steps above are perfect for producing a completed slideshow container. Cycling between build and run while developing the slides is less than ideal, however.

Mixing techniques can alleviate this pain. During development, we can volume mount the slides from the host into a running instance of the base image. This setup lets us make changes to the `slides.md` on the host, refresh the browser, and see the impact immediately, without tearing down, rebuilding, and re-running the container.

```bash
$ docker run -d -P -v `pwd`:/revealjs/md parente/revealjs
```

When we're satisfied with our work, we can build the final, fully contained image for migration and deployment.

```bash
$ docker build -t slideshow .
```

For the gritty details, see [the source](https://github.com/parente/dockerfiles/tree/master/revealjs) or the [parente/revealjs repository](https://index.docker.io/u/parente/revealjs/).

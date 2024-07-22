---
title: handlerbag on GitHub
date: 2011-01-23
---

I recently pushed for a small utility of mine called [handlerbag](http://github.com/parente/handlerbag) to github. The code defines a tiny controller for managing a bag of [Tornado](http://tornadoweb.org/) web server handlers. The controller supports auth using Google OpenID, dynamic loading and unloading of handlers, and simple persistence of handler configuration using anydbm.

The following handlers ship with the code:

- admin: Dirt simple UI for enabling, disabling, and configuring handlers
- hello: Hello world
- urlfetch: Downloads a resource given a URL to a local folder. Useful when I'm on my iPad and want to download something to my sync'ed Dropbox folder so I can check it out later on my desktop or laptop.
- rstpages: Monitors a folder for [reStructuredText](http://docutils.sourceforge.net/rst.html) files using [watchdog](https://github.com/gorakhargosh/watchdog) and renders them using [docutils](http://docutils.sourceforge.net/) as they change.
- xhrdrop: Allows cross-domain POSTs of plain text. Potentially useful for error reporting from web apps, though I haven't proven it yet.

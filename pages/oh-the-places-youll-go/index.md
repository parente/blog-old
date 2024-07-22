---
title: Oh! The Places You'll Go!
date: 2007-06-17
---

For those who read this, I'm no longer working on GNOME accessibility projects for IBM. I've been transferred to the [QEDWiki project](http://www.youtube.com/watch?v=ckGfhlZW0BY), and may or may not have accessibility duties in the long run, but possibly some in the short term.

Nevertheless, I'm writing up some final documentation on LSR in hope that someone will find it useful:

1. A [patterns document](http://www.gnome.org/~parente/lsr/pguide/) stating ways to solve different problems using the existing Perk scripting sytem.
2. A [LSR in retrospect document](http://www.gnome.org/~parente/lsr/retro) starting what I would change, if I were starting over again today.

I may work on making the latter changes myself in my spare time. I can see some usefulness is having a basic accessibility engine which I can use to script certain desktop actions or speech enable specific applications. For instance, maybe I want to listen to changes in a particular window (e.g. console with tail -f running, gaim chat window). Maybe I want some pre-recorded macros that perform a specific set of actions across applications that do not make their models public through dbus or another API. Or maybe I want a small toolbox window to augment an application with functions that aren't immediately available in its toolbar.

I still plan on contributing to GNOME accessibility. I have some patches outstanding for pygtk that will allow widgets drawn with pycairo to become visible to AT-SPI clients (e.g. Orca, Accerciser, GOK). I just have to find time to work on them.

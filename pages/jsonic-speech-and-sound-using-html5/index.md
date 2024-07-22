---
title: JSonic - Speech and sound using HTML5
date: 2010-05-10
---

I've released a new library called JSonic for text-to-speech synthesis and sound playback in browsers supporting HTML5 &lt;audio&gt;. The code is on <a href="http://github.com/uncopenweb/jsonic">GitHub</a> along with <a href="http://uncopenweb.github.com/jsonic">full documentation</a> of the JS and REST APIs.

The client API is implemented as a Dojo dijit.\_Widget subclass. Other client implementations are possible as long as they provide the same JS interface. The TTS synthesis is implemented server-side using <a href="http://espeak.sourceforge.net/">espeak</a> and <a href="http://www.tornadoweb.org/">Tornado</a>. Other server implementations are possible as long as they adhere to the REST API, and other speech engines can be plugged in rather easily.

The <a href="http://sites.google.com/site/uncopenweb/">UNC Open Web group</a> is looking to use JSonic to build self-voicing web games for kids with disabilities. I've already ported my <a href="http://mindtrove.info/spaceship">Spaceship!</a> game (<a href="http://github.com/parente/spaceship">also available on GitHub</a>) to use it instead of Outfox, and hope deploy it somewhere in the near future.

Bug reports, bug fixes, comments, questions, uses, and so on are welcome. Please use the issue tracker on the GitHub project page when reporting bugs.

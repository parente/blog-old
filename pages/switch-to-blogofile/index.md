---
title: My Switch to Blogofile
date: 2010-12-26
---

I saw Mike Pirnat's various posts (see <a href="http://mike.pirnat.com/2010/12/18/why-i-switched-to-blogofile/">#1</a> and <a href="http://mike.pirnat.com/2010/12/21/how-i-deploy-my-blogofile-blog-on-webfaction/">#2</a>) on <a href="http://planet.python.org/">Planet Python</a> about switching to <a href="http://www.blogofile.com/">Blogofile</a>. I noted with interest its static nature and his deploying it using git to Webfaction, but bookmarked it for later investigation. After all, Wordpress was working well enough relative to the amount of blogging I do. Still, its in-browser editor has always left me pining for something more friendly to posts heavy with code and/or custom markup.

It turns out <a href="http://www.cs.unc.edu/~gb/blog/2010/12/22/site-update/">Gary saw the same posts</a> from Pirnat and jumped all over switching to Blogofile. After he <a href="http://github.com/gbishop/blog">laid the groundwork</a> with a nice template and clean Wordpress export, I had few excuses left for sticking with WP. A couple of toddler naps later, here I am on my new Blogofile site. I'm using Pirnat's recipe for deploying on git post-receive, a simple HTML5 template forked from Gary's two-column layout, and a simple grayscale style. All I do is git commit posts locally, push to a repository on Webfaction, and let my scripts there build and deploy the site.

Maybe, just maybe, the ability to write in TextMate, choose between HTML or reST as desired, colorize code with ease, and deploy using git will push me to post more often.

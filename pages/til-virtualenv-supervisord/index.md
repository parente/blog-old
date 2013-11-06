title: Activating a virtualenv in supervisord
date: 2011-02-14



Here's a little script I started using today to activate a virtualenv, run a command in it, then deactivate the environment.



<script src="https://gist.github.com/826961.js?file=runinenv.sh"></script>

It works well in supervisord program sections.

<script src="https://gist.github.com/826961.js?file=supervisord.conf"></script>
---
title: virtualenv Bootstrapping
date: 2011-01-02
---

<a href="http://virtualenv.openplans.org/">virtualenv </a>is a tool to create isolated Python environments. <a href="http://pip.openplans.org/">pip</a> installs Python packages. Together, they're awesome.

In the virtualenv documentation, Ian Bicking gives a recipe for <a href="http://virtualenv.openplans.org/#creating-your-own-bootstrap-scripts"> creating project bootstrap scripts</a> that set up an environment and then perform custom steps to populate it. The bootstrap script is self-contained: it doesn't require the person running it to have virtualenv installed. The downside is that producing the bootstrap script requires running another script that invokes `virtualenv.create_bootstrap_script` and writing the result to disk.

If you're willing to treat virtualenv as a pre-requisite, there's an alternative recipe that doesn't require the script-creating-a-script level of indirection. Import the `virtualenv` module, define the hook functions in its scope, and then execute its `main` function.

For example, here's a bootstrap script that creates a virtual environment, installs the HEAD of the Tornado's master branch from GitHub, writes a script that runs a Tornado server with a static file handler pointing to a `www` directory, makes the run script executable, and dumps a hello world `index.html` file into the root of the static path.

<script src="https://gist.github.com/763048.js"> </script>

You can execute this script, giving it a path to where you want the virtual environment to reside. After it completes, you can activate that environment and execute the `run_server.py` script it generates to start the Tornado server. Visiting `http://localhost:8080/static/index.html` in your browser shows the hello world page the `setup_tornadoenv.py` generated.

```
$ ./setup_tornadoenv.py ~/envs/my_app
$ source ~/envs/my_app/bin/activate
$ run_server.py &
$ open http://localhost:8080/static/index.html
```

Of course, you can reuse the setup script to create additional, isolated environments.

```
$ deactivate      # get out of the my_app env
$ ./setup_tornadoenv.py ~/envs/my_other_app
$ . ~/envs/my_other_app/bin/activate
$ run_server.py --port=9000 &
$ open http://localhost:9000/static/index.html
```

If you install <a href="http://www.doughellmann.com/projects/virtualenvwrapper/">virtualenvwrapper</a>, switching among the separate server environments is even easier.

```
$ deactivate                  # get out of the my_other_app env
$ sudo pip install virtualenvwrapper
$ export WORKON_HOME=~/envs   # or add this to .bashrc or .bash_profile
$ source /usr/local/bin/virtualenvwrapper.sh # same here
$ workon my_app               # now in the my_app env
$ workon my_other_app         # now in the other
$ deactivate                  # now in the system env
```

You can always add arguments to the bootstrap script to increase its flexibility too. Imagine options for what version of Tornado to fetch, the default port number, manging the server under supervisord, etc.

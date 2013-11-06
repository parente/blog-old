title: pip Install From a Git Repo
date: 2010-12-28



[pip](http://pip.openplans.org/) installs Python packages. It knows about PyPI, various source control systems, and even local setup.py files. For example, to install Tornado HEAD from GitHub:

```console
$ sudo pip install -e git+https://github.com/facebook/tornado.git#egg=Tornado
```



To install Tornado 1.1 from PyPI:

```console
$ sudo pip install Tornado
```

To install Tornado from a local clone of the source:

```console
$ cd tornado
$ sudo pip install -e .
```

This last one really just symlinks the source folder into site-packages like the distutils develop option.

Uninstall is easy too and seems to be based on simple pattern matching.

```console
$ sudo pip uninstall tornado
```
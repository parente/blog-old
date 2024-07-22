---
title: Jupyter Tidbit: Kernels for text files in JupyterLab
date: 2018-08-24
excerpt: You can associate a Console panel and kernel with a text editor in JupyterLab, and use it to execute selected code, RStudio style.
author_comment: This post originates from a <a href="https://gist.github.com/parente/4affb14e025cf805ebd21703f117bc5d">gist</a> that supports comments, forks, and execution in <a href="https://mybinder.org/v2/gist/parente/4affb14e025cf805ebd21703f117bc5d/master">binder</a>.
template: notebook.mako
---

### Summary

You can associate a Console panel and kernel with a text editor in JupyterLab, and use it to execute selected code, RStudio style.

1. Create or open a text source file in JupyterLab.
2. Right click in the text editor panel.
3. Click _Create Console for Editor_.
4. Select a kernel matched to the programming language you want to execute in the file.
5. Notice the Console panel that appears.
6. Highlight one or more lines back in the text editor you'd like to run.
7. Press _Shift-Enter_ to execute those lines.
8. Notice the input and output that appears in the Console.

### Example

[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gist/parente/4affb14e025cf805ebd21703f117bc5d/master)

Here's a screencast showing how to launch a kernel and console for a simple `tryit.py` file. Click the Binder button to try this example yourself.

![Screencast of attaching a kernel and console to a tryit.py file in JupyterLab](https://gist.githubusercontent.com/parente/4affb14e025cf805ebd21703f117bc5d/raw/jlab-console-for-text.gif)

### Why is this useful?

You may want to develop a traditional Python (or other language) module alongside your notebooks. Attaching a kernel-plus-console to the source file allows you to iterate quickly on developing, executing, and evaluating your work without leaving the Jupyter environment or having to copy/paste code between a notebook / console and the module file.

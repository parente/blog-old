---
title: Jupyter Tidbit: Use nbconvert to clear notebook outputs
date: 2018-08-22
excerpt: nbcovert has a preprocessor that clears cell outputs from notebook files, leaving cell inputs intact.
author_comment: This post originates from a <a href="https://gist.github.com/parente/bfd7548ee08b6e377da85f8e4f88d6b8">gist</a> that supports comments and forks.
---

### Summary

[nbconvert](http://nbconvert.readthedocs.io/en/stable/) has a preprocessor that clears cell outputs from notebook files, leaving cell inputs intact.

### Example

The following shell command reads `my_input_notebook.ipynb`, removes its cell outputs, prints the cleaned notebook to stdout, and redirects that output to a new notebook file named `my_output_notebook.ipynb`.

```bash
jupyter nbconvert my_input_notebook.ipynb --to notebook --ClearOutputPreprocessor.enabled=True --stdout > my_output_notebook.ipynb
```

The following command works similiarly, but without using a redirect.

```bash
jupyter nbconvert my_input_notebook.ipynb --to notebook --ClearOutputPreprocessor.enabled=True --output my_output_notebook
```

### Why is this useful?

One day, you may run a notebook, walk away, and return later to find your notebook has produced so much output that it has brought your browser to its knees ... after autosaving. You'll try to reload that notebook to see what went wrong, only to find that your browser tab slows to a crawl and crashes once again. Clearing outputs at the command line is one way to get out of this sticky situation.

On a lighter note, you may just want to quickly purge your notebook of output before sharing it, without having to open it in Jupyter Notebook, JupyterLab, etc.

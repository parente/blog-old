### Summary

The `%run` magic provided by IPython not only supports the execution of regular Python scripts, it also runs Jupyter Notebook files (.ipynb). 

### Example

[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gist/parente/8932dac5a430dba4c17f49af16568da7/master)

The `run_demo.ipynb` notebook below uses `%run` to execute all of the cells in `reusable_stuff.ipynb`. Once it does, both globals defined in `reusable_stuff` are available in `run_demo` for use.

### Why is this useful?

You can maintain a handy notebook of useful recipes that you can than `%run` to reuse in other notebooks. Just remember that this setup can *decrease* the reproducibility of your work unless you provide your recipe notebook alongside any notebook that uses it when you share.
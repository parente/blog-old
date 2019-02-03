### Summary

You can get a list of standard paths Jupyter tools use for configuration, static assets, and temporary runtime files by running the command `jupyter --paths`.

### Example

When I run `jupyter --paths` on my laptop, I see the following output:

```
config:
    /Users/parente/.jupyter
    /Users/parente/miniconda3/envs/jupyter/etc/jupyter
    /usr/local/etc/jupyter
    /etc/jupyter
data:
    /Users/parente/Library/Jupyter
    /Users/parente/miniconda3/envs/jupyter/share/jupyter
    /usr/local/share/jupyter
    /usr/share/jupyter
runtime:
    /Users/parente/Library/Jupyter/runtime
```

### Why is this useful?

You can use the list of paths to locate and troubleshoot errant extensions and configuration values. You can also use the programmatic equivalents (e.g., [`import jupyter_core.paths` in Python](https://jupyter-core.readthedocs.io/en/latest/paths.html), [`var jp = require('jupyter-paths')` in JavaScript](https://github.com/nteract/jupyter-paths)) to read/write appropriate configs and data when building your own Jupyter compatible tools.
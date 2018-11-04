### Summary

IPython's `display()` function can return a `DisplayHandle` object. You can use a `DisplayHandle` to update the output of one cell from any other cell in a Jupyter Notebook.

### Example

[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gist/parente/5cab90125191d523e76fcb398f30da05/master?filepath=display_handle.ipynb)

The `display_handle.ipynb` notebook below calls `display(display_id=True)` to get a display handle instance. It then uses the `DisplayHandle.display` method to show some initial, static Markdown. Later, in a different cell, it calls `DisplayHandle.update` in a loop to show a range of emoji characters.

### Why is this useful?

You can use display handles to redraw matplotlib plots, re-render DataFrame tables, print log file updates, etc. from code executed anywhere in the notebook.
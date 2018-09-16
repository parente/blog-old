### Summary

IPython *shell assignment* (the `!` operator) evaluates a command using the local shell (e.g., `bash`) and returns a *string list*  (`IPython.utils.text.SList`). An `SList` is a list-like object containing "chunks" of stdout and stderr, properties for accessing those chunks in different forms, and convenience methods for operating on them.

### Example

[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gist/parente/b6ee0efe141822dfa18b6feeda0a45e5/master?filepath=SList.ipynb)

The `SList.ipynb` notebook below uses `SList` properties to access the output of a shell command as a list-like of strings, a newline-separated string, a space-separated string, and a list of `pathlib.Path` objects. The notebook then uses the `SList.fields()` and `SList.grep()` methods to extract columns from and search command output.

### Why is this useful?

You can take advantage of the properties and methods of an `SList` to transform shell output into forms more amenable to further operations in Python.

### For more information

See the [IPython documentation about Shell Assignment](https://ipython.readthedocs.io/en/stable/interactive/python-ipython-diff.html#shell-assignment) for examples of executing shell commands with optional Python values as inputs. See the [IPython documentation about String Lists](https://ipython.readthedocs.io/en/stable/interactive/shell.html?highlight=slist#string-lists) for additional demontrations of the utility of `SLists`.
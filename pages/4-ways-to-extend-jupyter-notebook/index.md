Title: Four Ways to Extend Jupyter Notebook
Date: 2015-07-07

[Jupyter Notebook](https://try.jupyter.org/) (n&#233;e [IPython Notebook](http://ipython.org)) is a web-based environment for interactive computing in notebook documents. In addition to supporting the execution of user-defined code, Jupyter Notebook has a variety of plug-in points which one can use to extend the capabilities of the authoring environment itself. In this post, I'll touch on four of these extension mechanisms, some better known than others, and finish off with an example of how to package and distribute a set of cooperating extensions.

## 1. Kernels

Kernels are probably the most well-known type of extension to Jupyter Notebook. Kernels provide the Notebook, and [other Jupyter frontends](https://github.com/jupyter/qtconsole), the ability to execute and introspect user code in a [variety of languages](https://github.com/ipython/ipython/wiki/IPython%20kernels%20for%20other%20languages).

Installing a kernel amounts to satisfying its dependencies (e.g., [IRKernel requires a working installation of R among other things](https://github.com/IRkernel/IRkernel/blob/master/README.md)) and writing a kernel spec file into the Jupyter user's configuration directory (e.g., `~/.jupyter/kernels/<kernel name>`). Kernel authors usually provide documentation with manual steps to follow, at least, or a language-specific installer at best.

Example kernel spec file for IRKernel:
```
{
    "argv": ["R", "-e", "IRkernel::main()", "--args", "{connection_file}"],
    "display_name":"R"
}                                                                                       
``` 

Creating new kernels can be as simple as implementing [a Python `IPython.kernel.zmq.kernelbase.Kernel` subclass](http://ipython.org/ipython-doc/dev/development/wrapperkernels.html) or as complex as [implementing a kernel program in your language of choice](http://ipython.org/ipython-doc/dev/development/kernels.html) that talks [the Jupyter protocol over ZeroMQ](http://ipython.org/ipython-doc/dev/development/messaging.html). The Jupyter documentation, [experienced kernel authors](http://andrew.gibiansky.com/blog/ipython/ipython-kernels/), and the source of existing community contributed kernels all serve as great references in this task. 

## 2. Kernel Extensions

[Kernel extensions](http://ipython.org/ipython-doc/dev/config/extensions/index.html) are Python modules that can modify the interactive shell environment within an IPython kernel. Such extensions can register [magics](https://ipython.org/ipython-doc/3/interactive/tutorial.html#magic-functions), define variables, and generally modify the user namespace to provide new features for use within code cells. Kernel extensions are not exclusive to the Jupyter Notebook frontend, but many [community contributed extensions](https://github.com/ipython/ipython/wiki/Extensions-Index) do target its browser-powered display system in particular.

The IPython kernel ships with four magics that enable the management of extensions from within notebooks (or other Jupyter interfaces).

1. `%install_ext <URL|path>` installs a Python module as an extension 
2. `%load_ext <name>` loads the extension module and invokes its load function
3. `%reload_ext <name>` invokes the extension module unload function, reloads the extension module itself, and then invokes its load function 
4. `%unload_ext <name>` invokes the extension module unload function and drops the module reference

Likewise, the Jupyter configuration system exposes the `InteractiveShellApp.extensions` trait which loads a list of Python modules for every new IPython kernel launched.

```
c.InteractiveShellApp.extensions = [
    'mypackage.myextension'
]
```

Writing a Python module that can serve as a kernel extension requires implementing a `load_ipython_extension` function and optionally implementing `unload_ipython_extension`. Both functions receive an [`InteractiveShell`](https://ipython.org/ipython-doc/dev/api/generated/IPython.core.interactiveshell.html) instance as their one and only parameter. The loading function typically uses methods on the instance to add features while the unload function cleans them up.

## 3. Notebook Extensions

Jupyter Notebook extensions (*nbextensions*) are JavaScript modules that can load on most major web pages comprising the Notebook frontend. Once loaded, they have access to the complete page DOM and frontend Jupyter JavaScript API with which to modify the notebook, dashboard, editor, etc. user experience. As their name suggests, these extensions are exclusive to the Notebook frontend for Jupyter and [typically add features to the notebook authoring portion of the user interface.](https://github.com/ipython-contrib/IPython-notebook-extensions/wiki/Home_3x)

Notebook extension mangagement is burgeoning area of interest in the Jupyter project. Today, the recommended way of installing, loading, and unloading extensions requires running a few snippets of code either within an IPython notebook document or in an external Python script.

To install, for example, [minrk's](https://twitter.com/minrk) gist nbextension, you can execute the following code in a notebook.

```
import IPython
IPython.html.nbextensions.install_nbextension('https://rawgithub.com/minrk/ipython_extensions/master/nbextensions/gist.js', user=True)
```

Once installed, you can load the gist extension by executing the following JavaScript magic in a code cell.

```
%%javascript
IPython.load_extensions('gist');
```

The cell above emits a `<script>` element into the output area of the notebook cell. The code in that element loads the gist JavaScript module from the Notebook server backend. In the case of the gist extension, a button appears in the toolbar for posting the current notebook document as a gist.

After you save the notebook, the `<script>` element will persist in it. This script block will execute whenever you reload this particular notebook. To stop this behavior, you can delete the cell and refresh the page.

If you want to load the extension automatically whenever you open any notebook document, you can add it to the notebook configuration section of your profile.

```
from IPython.html.services.config import ConfigManager
ip = get_ipython()
cm = ConfigManager(parent=ip, profile_dir=ip.profile_dir.location)
cm.update('notebook', {"load_extensions": {"gist": True}})
```

You can stop the extension from loading automatically across notebooks using similar code. Pay attention to the use of `None` instead of `False` as the value required to disable the extension.

```
from IPython.html.services.config import ConfigManager
ip = get_ipython()
cm = ConfigManager(parent=ip, profile_dir=ip.profile_dir.location)
# update with None, not False, to disable auto loading
cm.update('notebook', {"load_extensions": {"gist": None}})
```

Take note of the first parameter value in the `ConfigManager.update` invocation. It associates the extension with one of the primary Jupyter Notebook views, in this case the notebook editor view. While most extensions, like gist, operate on the notebook view, it is possible to write and load extensions against other views such as the text editor (`edit`) and dashboard (`tree`), or all views (`common`).


Creating a Notebook extension 

Writing one: AMD, requirejs, DOM manipulation, Jupyter JS API


## 4. Notebook Server Extensions

Python Tornado handlers

## A Word on Packaging and Distribution

The story on how to package and distribute extensions to Jupyter Notebook is still evolving. You can accomplish 
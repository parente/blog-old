Title: Four Ways to Extend Jupyter Notebook
Date: 2015-07-19

[Jupyter Notebook](https://try.jupyter.org/) (n&#233;e [IPython Notebook](http://ipython.org)) is a web-based environment for interactive computing in notebook documents. In addition to supporting the execution of user-defined code, Jupyter Notebook has a [variety of plug-in points](http://carreau.gitbooks.io/jupyter-book/content/notebook-extensions.html) that you can use to extend the capabilities of the authoring environment itself. In this post, I'll touch on four of these extension mechanisms and finish off with a word on [packaging and distribution](#pkg-dist):

1. [Kernels](#kernels)
2. [IPython Kernel Extensions](#ipy-kernel-exts)
3. [Notebook Extensions](#nb-extensions)
4. [Notebook Server Extensions](#nb-server-exts)

<a name="caveats"></a>
## Caveat Implementor

A few words of caution before you proceed. First, I wrote this post based on what exists in the current master branch of the [jupyter/notebook](https://github.com/jupyter/notebook) project. At the time of this writing, that project is close to reaching its first stable release (Jupyter Notebook v4.0) after the ["Big Split"](https://blog.jupyter.org/2015/04/15/the-big-split/). Before it does, details may change and impact my writing and code samples below.

Second, while all of the extension mechanisms I describe below do exist in the current stable release of the Notebook project (i.e., IPython Notebook v3.2.1), names and packages have changed during the "Big Split". You *will* need to adjust many of my code samples below if you wish to backport them, albeit often in trivial ways (e.g., `notebook.nbextensions` &rarr; `IPython.html.nbextensions`).

Third, the story of [extensions for Jupyter is still evolving](https://github.com/jupyter/notebook/issues/116). Not all of the APIs and techniques I mention in this post are well-documented or considered stable yet.

<a name="kernels"></a>
## 1. Kernels

Kernels are probably the most well-known type of extension to Jupyter Notebook. Kernels provide the Notebook, and [other Jupyter frontends](https://github.com/jupyter/qtconsole), the ability to execute and introspect user code in a [variety of languages](https://github.com/ipython/ipython/wiki/IPython%20kernels%20for%20other%20languages).

Installing a kernel amounts to satisfying its dependencies (e.g., [IRKernel requires a working installation of R among other things](https://github.com/IRkernel/IRkernel/blob/master/README.md)) and writing a kernel spec file into the Jupyter user's configuration directory (e.g., `~/.jupyter/kernels/<kernel name>`). Kernel authors usually provide documentation with manual steps to follow, at least, or a language-specific installer, at best.

For reference, the kernel spec for IRKernel appears below.

```json
{
    "argv": ["R", "-e", "IRkernel::main()", "--args", "{connection_file}"],
    "display_name":"R"
}
```

Creating new kernels can be as simple as implementing [a Python `ipykernel.kernelbase.Kernel` subclass](http://jupyter-client.readthedocs.org/en/latest/wrapperkernels.html) or as complex as [implementing a kernel program in your language of choice](http://jupyter-client.readthedocs.org/en/latest/kernels.html) that talks [the Jupyter protocol over ZeroMQ](http://jupyter-client.readthedocs.org/en/latest/messaging.html). The [jupyter_client documentation](http://jupyter-client.readthedocs.org/en/latest/), [experienced kernel authors](http://andrew.gibiansky.com/blog/ipython/ipython-kernels/), and the source of existing community contributed kernels all serve as great references in this task. 

<a name="ipy-kernel-exts"></a>
## 2. IPython Kernel Extensions

[IPython Kernel extensions](http://ipython.readthedocs.org/en/master/config/extensions/index.html) are Python modules that can modify the interactive shell environment within an IPython kernel. Such extensions can register [magics](http://ipython.readthedocs.org/en/master/interactive/reference.html#defining-magics), define variables, and generally modify the user namespace to provide new features for use within code cells. Kernel extensions are not exclusive to the Jupyter Notebook frontend, but many [community contributed extensions](https://github.com/ipython/ipython/wiki/Extensions-Index) do target its browser-powered display system in particular.

The IPython kernel ships with four magics that allow for the management of extensions from within Jupyter Notebook (or other Jupyter interfaces).

1. `%install_ext <URL|path>` installs a Python module as an extension ([deprecated](https://github.com/ipython/ipython/pull/8601))
2. `%load_ext <name>` imports the extension module and invokes its load function
3. `%reload_ext <name>` invokes the extension module unload function, re-imports the extension module itself, and then invokes its load function 
4. `%unload_ext <name>` invokes the extension module unload function and drops the module reference

The load, reload, and unload magics act solely on the kernel associated with the notebook in which they appear. Every time that kernel restarts, you must run the load magic again to re-enable the extension.

The Jupyter configuration system exposes the `InteractiveShellApp.extensions` list trait to automate the loading of kernel extensions. Adding a module name to the list causes Jupyter to automatically load that extension whenever an IPython kernel starts. For example, you can add the following lines to the Notebook configuration file in your Jupyter profile (e.g., `~/.jupyter/profile_default/jupyter_notebook_config.py`) to automatically load module `my_package.my_kernel_extension` any time an IPython kernel starts or restarts.

```python
c.InteractiveShellApp.extensions = [
    'my_package.my_kernel_extension'
]
```

Writing a Python module that can serve as a kernel extension requires implementing a `load_ipython_extension` function and optionally implementing a `unload_ipython_extension` function. Both functions receive an [`InteractiveShell`](https://ipython.org/ipython-doc/dev/api/generated/IPython.core.interactiveshell.html) instance as their one and only parameter. The loading function typically uses methods on the instance to add features while the unload function cleans them up. For instance, a minimal extension that defines skip `%%skip`, a cell magic that turns the current cell into a no-op, appears below.

```python
def skip(line, cell=None):
    '''Skips execution of the current line/cell.'''
    pass

def load_ipython_extension(shell):
    '''Registers the skip magic when the extension loads.'''
    shell.register_magic_function(skip, 'line_cell')

def unload_ipython_extension(shell):
    '''Unregisters the skip magic when the extension unloads.'''
    del shell.magics_manager.magics['cell']['skip']
```

<a name="nb-extensions"></a>
## 3. Notebook Extensions

Jupyter Notebook extensions (*nbextensions*) are JavaScript modules that can load on most major views constituting the Notebook frontend. Once loaded, they have access to the complete page DOM and frontend Jupyter JavaScript API with which to modify the user experience. As their name suggests, these extensions are exclusive to the Notebook frontend for Jupyter and [typically add features to the notebook authoring user interface.](https://github.com/ipython-contrib/IPython-notebook-extensions/wiki/Home_3x)

Today, the recommended way of installing, loading, and unloading extensions requires running a few snippets of code either within a notebook associated with an IPython kernel or in an external Python script. To install, for example, [minrk's gist nbextension](https://github.com/minrk/ipython_extensions), you can execute the following code in a notebook.

```python
import notebook.nbextensions
notebook.nbextensions.install_nbextension('https://rawgithub.com/minrk/ipython_extensions/master/nbextensions/gist.js', user=True)
```

The code above downloads the JavaScript file and copies it into your Jupyter configuration directory (e.g., `~/.jupyter/nbextensions`). Once installed, you can load the gist extension by executing the following JavaScript in a code cell.

```javascript
%%javascript
Jupyter.utils.load_extensions('gist')
```

The cell above emits a `<script>` element into the output area of the notebook cell. That script loads the `gist.js` JavaScript module from the Notebook server backend. On load, the gist extension adds a button appears to the toolbar which you can click to post the current notebook document as a gist.

After you save the notebook, the `<script>` element will persist in it. This script block will execute whenever you (but [not necessarily others](http://jupyter-notebook.readthedocs.org/en/latest/security.html#our-security-model)) open this particular notebook document. To stop this behavior, you can delete the cell and refresh the page.

If you want to load the extension automatically whenever you open *any* notebook document, you must add the extension to the notebook configuration section of your Jupyter profile. You can do so with the following code.

```python
from notebook.services.config import ConfigManager
ip = get_ipython()
cm = ConfigManager(parent=ip, profile_dir=ip.profile_dir.location)
cm.update('notebook', {"load_extensions": {"gist": True}})
```

You can stop the extension from loading automatically across notebooks using similar code. Pay attention to the use of `None` instead of `False` as the value that disables the extension.

```python
from notebook.services.config import ConfigManager
ip = get_ipython()
cm = ConfigManager(parent=ip, profile_dir=ip.profile_dir.location)
# update with None, not False, to disable auto loading
cm.update('notebook', {"load_extensions": {"gist": None}})
```

Take note of the first parameter value in the `ConfigManager.update` invocation. It associates the extension with one of the primary Jupyter Notebook views, in this case the notebook editor view. While most extensions, like gist, operate on the notebook view, it is possible to write and load extensions against other views such as the text editor (`edit`) and dashboard (`tree`), or all views (`common`).

To write a new extension, you must implement your logic in a JavaScript file conforming to the [AMD specification](https://en.wikipedia.org/wiki/Asynchronous_module_definition) so that Jupyter can load it using [RequireJS](http://requirejs.org/). You should define and export a `load_ipython_extension` function in your module so that Jupyter can invoke it after initializing its own components. Within that function, you are free to manipulate the DOM of the page, invoke Jupyter JavaScript APIs, listen for Jupyter events, load other modules, and so on.

As an example, here is an extension that registers a command-mode hotkey to show a dialog of notebook cell counts.

```javascript
define([
    'base/js/namespace'
], function(Jupyter) {
    var exports = {};

    // Show counts of cell types
    var show_stats = function() {

        // Get counts of each cell type
        var cells = Jupyter.notebook.get_cells();
        var hist = {};
        for(var i=0; i < cells.length; i++) {
            var ct = cells[i].cell_type;
            if(hist[ct] === undefined) {
                hist[ct] = 1;
            } else {
                hist[ct] += 1;
            }
        }

        // Build paragraphs of cell type and count
        var body = $('<div>');
        for(var ct in hist) {
            $('<p>').text(ct+': '+hist[ct]).appendTo(body);
        }

        // Show a modal dialog with the stats
        Jupyter.dialog.modal({
            title: "Notebook Stats",
            body: body,
            buttons : {
                "OK": {}
            }
        });
    };

    // Wait for notification that the app is ready
    exports.load_ipython_extension = function() {
        // Then register command mode hotkey "s" to show the dialog
        Jupyter.keyboard_manager.command_shortcuts.add_shortcut('s', show_stats);
    };

    return exports;
});
```

<a name="nb-server-exts"></a>
## 4. Notebook Server Extensions

[Jupyter Notebook server extensions](http://carreau.gitbooks.io/jupyter-book/content/notebook-extensions.html#server-side-handler) are Python modules that load when the Notebook web server application starts. The only way to load server extensions at present is by way of the Jupyter configuration system. You must specify the extensions to load prior to starting the Jupyter Notebook server itself. Any changes to the list of extensions or the extensions themselves require a restart of the Notebook process to take effect.

For example, you can add the following lines to the Notebook configuration file in your Jupyter profile (e.g., `~/.jupyter/profile_default/jupyter_notebook_config.py`) to automatically load server extension `my_package.my_server_extension` when the Notebook app launches.

```python
c.NotebookApp.server_extensions = [
    'my_package.my_server_extension'
]
```

Creating a Python module that acts as a server extension requires implementing a `load_jupyter_server_extension` function. The function receives an instance of `Jupyter.notebook.notebookapp.NotebookApp` as its sole parameter. The function can use functions and attributes of this instance to customize and extend the server behavior. Most notably, the `web_app` attribute of the `NotebookApp` instance refers to an instance of a [`tornado.web.Application`](http://tornado.readthedocs.org/en/latest/web.html) subclass. You can register new `tornado.web.RequestHandler`s via that instance to extend the backend API of Jupyter Notebook.

To demonstrate the concept, an extension that adds a (dumb) "hello world" handler to the Notebook server appears below. (More compelling examples likely involve both Notebook server and frontend extensions working in conjunction.)

```python
from notebook.utils import url_path_join
from notebook.base.handlers import IPythonHandler

class HelloWorldHandler(IPythonHandler):
    def get(self):
        self.finish('Hello, world!')

def load_jupyter_server_extension(nb_app):
    '''
    Register a hello world handler.

    Based on https://github.com/Carreau/jupyter-book/blob/master/extensions/server_ext.py
    '''
    web_app = nb_app.web_app
    host_pattern = '.*$'
    route_pattern = url_path_join(web_app.settings['base_url'], '/hello')
    web_app.add_handlers(host_pattern, [(route_pattern, HelloWorldHandler)])
```

<a name="pkg-dist"></a>
## A Final Word: Packaging and Distribution

Packaging and distributing extensions is a somewhat ad-hoc process at the moment. [Planning](https://jupyter.hackpad.com/Packaging-crate-PbIgxnC71or) and [discussion](https://github.com/jupyter/notebook/issues/116) are in progress to improve the state of affairs. That said, it is possible to share your work with a bit of effort today. For example, the sample `setup.py` below shows how a custom [setuptools](https://pythonhosted.org/setuptools/) command class can install IPython kernel extensions, Jupyter Notebook JavaScript extensions, and Jupyter server extensions.

```python
import os
from setuptools import setup
from setuptools.command.install import install

from Jupyter.notebook.nbextensions import install_nbextension
from Jupyter.notebook.services.config import ConfigManager

EXT_DIR = os.path.join(os.path.dirname(__file__), 'myext')
SERVER_EXT_CONFIG = "c.NotebookApp.server_extensions.append('myext.my_handler')"

class InstallCommand(install):
    def run(self):
        # Install Python package, possibly containing a kernel extension
        install.run(self)
        
        # Install JavaScript extensions, for notebook, dashboard, and editor screens
        install_nbextension(EXT_DIR, overwrite=True, user=True)
        cm = ConfigManager()
        cm.update('notebook', {"load_extensions": {'myext_js/notebook': True}})
        cm.update('tree', {"load_extensions": {'myext_js/dashboard': True}})
        cm.update('edit', {"load_extensions": {'myext_js/editor': True}})

        # Install Notebook server extension
        fn = os.path.join(cm.profile_dir, 'jupyter_notebook_config.py')
        with open(fn, 'r+') as fh:
            lines = fh.read()
            if SERVER_EXT_CONFIG not in lines:
                fh.seek(0, 2)
                fh.write('\n')
                fh.write(SERVER_EXT_CONFIG)

setup(
    name='myext',
    version='0.1',
    packages=['myext'],
    cmdclass={
        'install': InstallCommand
    }
)
```

If the code seems lengthy, consider [jupyter-pip](https://github.com/jdfreder/jupyter-pip) which wraps some of the techniques above (and others) in a nice, reusable package. No matter which approach you choose, a user can open a Python notebook, run `pip install` against the root of your extension project, and wind up with all of your extension components put in their proper place. But not all is roses: Building packages for PyPI, supporting `pip uninstall`, and running the install outside of an active Jupyter Notebook context all require extra work.
Title: Four Ways to Extend Jupyter Notebook
Date: 2015-07-07

[Jupyter Notebook](https://try.jupyter.org/) (née [IPython Notebook](http://ipython.org)) is a web-based notebook environment for interactive computing. In addition to supporting the execution of user-defined code in notebook documents, Jupyter Notebook has a variety of code plug-in points which one can use to extend the capabilities of the tool itself. In this post, I'll touch on four of these extension mechanisms, some better known than others, and finish off with an example of how to package and distribute a set of cooperating extensions.

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

%load_ext
%install_ext
%reload_ext
%unload_ext

## 3. Notebook Frontend Extensions

JavaScript requirejs, AMD

## 4. Notebook Server Extensions

Python Tornado handlers

## A Word on Packaging and Distribution

The story on how to package and distribute extensions to Jupyter Notebook is still evolving. You can accomplish 
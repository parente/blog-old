---
title: GtkBuilder/Glade on IronPython
date: 2009-08-28
---

Thanks to Stephane for his answer to my query about [using GtkBuilder in IronPython](http://blog.reblochon.org/2009/08/gtkbuilder-on-ironpython.html). It turns out his [Gtk#Beans](http://gitorious.org/gtk-sharp-beans) package provides the magic sauce that is currently missing from ~~gtk# trunk~~ the current stable release.

For completeness, here's the code I sent him that accomplishes the same thing using the older Glade.XML object for those that are interested. It answers a [long standing mailing list question](http://lists.ironpython.com/pipermail/users-ironpython.com/2005-August/000968.html) about using Glade.XML.Autoconnect in IronPython.

```python
import clr
clr.AddReference('gtk-sharp')
clr.AddReference('glade-sharp')
import Gtk
import Glade

def PyGladeAutoconnect(gxml, target):
    def _connect(handler_name, event_obj, signal_name, *args):
        name = ''.join([frag.title() for frag in signal_name.split('_')])
        event = getattr(event_obj, name)
        event += getattr(target, handler_name)

    # add all widgets
    for widget in gxml.GetWidgetPrefix(''):
        setattr(target, gxml.GetWidgetName(widget), widget)
    # connect all signals
    gxml.SignalAutoconnectFull(_connect)

class Application:
    def __init__(self):
        gxml = Glade.XML("test.glade", "window1", None)
        PyGladeAutoconnect(gxml, self)
        # window1 comes from glade file
        self.window1.ShowAll()

    def onWindowDelete(self, o, args):
        # connected via glade file definition
        Gtk.Application.Quit()

Gtk.Application.Init()
app = Application()
Gtk.Application.Run()
```

---
tags: accerciser, at-spi, validation
title: Validate Your Accessibility
date: 2008-01-16
---

Eitan [committed a new plug-in](http://monotonous.org/?p=48) for Accerciser that makes it dirt simple to find basic accessibility problems. You know, the ones that cause grief for apps like Orca, GOK, On-Board, etc. To use it, run Accerciser, point it at part of a GUI, click validate, and wait for the report.

The rules in the plug-in aren't the greatest right now. But the plug-in is extensible with new rule sets called _schemas_. For instance, you could have a 'Desktop' schema to check basic GUI problems, a 'Web' schema to test document accessibility, and an 'Orca' schema to check a program's fitness for Orca scripting. The sky's the limit, and I'm sure Eitan, Will, and company will come up with quite a few useful tests.

To ward off any fear brought on by the word 'schema,' I should note that they're really just Python modules with simple, three-method classes in them. For example:

```python
class CheckFocusable(Validator):
  def condition(self, acc):
    # only test accessibles that have the action interface
    return acc.queryAction()
  def after(self, acc, state, view):
    # check an accessible after checking its descendants
    # acc is the accessible
    # state is a dictionary of whatever you need to store across tests
    # view logs errors, warnings, etc.
    pass
  def before(self, acc, state, view):
    # check an accessible before checking its descendants
    s = acc.getState()
    if not s.contains(STATE_FOCUSABLE):
      view.error('actionable widget is not focusable')
```

No more excuses for inaccessible apps now, right?

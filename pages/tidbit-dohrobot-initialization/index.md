---
title: doh.robot Initialization
date: 2009-03-13
---

The doh.robot module for Dojo clicks a special text field inserted into the top-left of the test page during its initialization. If you obscure this magic field, the robot hangs.

If you're writing your test cases separate from the page under test (always a good idea), dojo.robotx craftily hides the iframe containing the page to test until the robot is ready. If you're not using dojo.robotx (my constraint), you must be careful to avoid that magic text box in a similar fashion.

---
title: Python operator Module
date: 2010-12-27
---

Today I learned about the Python operator module in the standard library while playing with Blogofile. The module includes functional equivalents of standard Python operators. These are particularly useful for sorting.

```python
import operator
class O:
  def __init__(self, val):
    self.val = val
arr = [O(4), O(5), O(1), O(2)]
# sort by value attribute of the object
arr.sort(key=operator.attrgetter('val'))
print [i.val for i in arr]
```

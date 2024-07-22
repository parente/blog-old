---
title: Python Weak References
date: 2008-04-30
---

The weakref module in the Python standard library is a useful tool for creating Python references without impeding object destruction. This tutorial covers the basics of weak references, and introduces a Proxy class enabling weak references to method objects.

## Hefty, hefty, hefty

Strong references are pointers to objects that have an effect on their reference counts, and hence their lifetime and destruction. Strong references are what you see all the time when you assign an object to a variable:

```python
>>> a = [1,2,3]
>>> b = a
```

In this case, the list object has two strong references to it stored in a and b. The list will not be destroyed until both references are released:

```python
>>> del a
>>> del b
```

In this case, it is hard to tell exactly when the list object is destroyed. A class with a verbose **del** method provides a better example:

```python
class Foo(object):
     def __init__(self):
       self.obj = None
       print 'created'

     def __del__(self):
         print 'destroyed'

     def show(self):
         print self.obj

     def store(self, obj):
         self.obj = obj
```

Again, if we create two strong references to a single instance of Foo, we can now see that it is not destroyed until both references are discarded:

```python
>>> a = Foo()
created
>>> b = a
>>> del a
>>> del b
destroyed
```

## Wimpy, wimpy, wimpy

Weak references, on the other hand, have no effect on the reference count for an object. The existence of a weak reference never impedes object destruction. That is, if an object has only weak references, it will be destroyed.

To create a weak reference to an object, you use the weakref.ref function. The call requires a strong reference to an object as the first parameter and returns a weak reference to that object:

```python
import weakref
>>> a = Foo()
created
>>> b = weakref.ref(a)
```

A temporary strong reference can be created from a weak reference by calling it:

```python
>>> a == b()
True
>>> b().show()
None
```

Notice that when we delete the one and only strong reference to our Foo object, it is immediately destroyed:

```python
>>> del a
destroyed
```

If we try to call our weak reference after the object has been destroyed, we get None in its place:

```python
>>> b() is None
True
```

As a more transparent alternative to weakref.ref, we can use weakref.proxy. This call requires a strong reference to an object as its first argument and returns a weak reference proxy. The proxy behaves just like a strong reference, but throws an exception when used after the target is dead:

```python
>>> a = Foo()
created
>>> b = weakref.proxy(a)
>>> b.store('fish')
>>> b.show()
fish
>>> del a
destroyed
>>> b.show()
Traceback (most recent call last):
  File "", line 1, in ?
ReferenceError: weakly-referenced object no longer exists
```

## Cyclic references

A need for weak references arises when objects have strong references forming a cycle. In this case, object a has a reference to b and vice versa:

```python
>>> a = Foo()
created
>>> b = Foo()
created
>>> a.store(b)
>>> b.store(a)
>>> del a
>>> del b
```

The destructor methods on a and b are never called and the objects continue to live until the interpreter exits. This example may seem contrived, but it is representative of patterns having a bidirectional relationship. If a parent GUI widget has a reference to a child widget while the child has a reference to its container parent, a cyclic reference exists. A node in a doubly linked list has a cyclic relationship. Even a node in a singly linked list may be part of a cycle that impedes proper object destruction:

```python
>>> a = Foo()
created
>>> b = Foo()
created
>>> c = Foo()
created
>>> a.store(b)
>>> b.store(c)
>>> c.store(a)
>>> del a

>>> del b
>>> del c
```

A solution to this problem is to store weak references:

```python
class Foo(object):

    ...

    def show(self):
        print self.obj()

    def store(self, obj):
        self.obj = weakref.ref(obj)
```

With this implementation, the two objects are destroyed when strong references a and b are deleted:

```python
>>> a = Foo()
created
>>> b = Foo()
created
>>> c = Foo()
created
>>> a.store(b)
>>> b.store(c)
>>> c.store(a)
>>> del a
destroyed
>>> del b
destroyed
>>> del c
destroyed
```

## Dead-on-arrival

The [weakref module](http://docs.python.org/lib/module-weakref.html) cannot create weak references to all objects. For instance, passing a Python list, tuple, dictionary, numeric, string, or None will raise a TypeError exception. This limitation and response is reasonable. However, sometimes creation of a weak references fails silently:

```python
>>> a = Foo()
created
>>> b = Foo()
created
>>> a.store(b.show) # store creates a weak reference
>>> a.show()
None
```

Shouldn't the variable a hold a reference to the bound method show on the instance in b? No. The reason for this seemingly strange behavior is that bound methods are created on demand when accessed on an instance. In this code, the bound method b.show is created and passed to the method Foo.store. This method stores a weak reference to b.show in the instance variable a.obj. Once the store method ends, there is no longer a strong reference to the bound method b.show and so it is immediately destroyed. In a sense, the weak reference in a.obj is dead-on-arrival.

## Extending weak references

Even though the weakref module cannot create weak references to bound methods, you can create a weak reference proxy class that works for bound methods as well as other objects. The following code from the Linux Screen Reader project accomplishes exactly this goal. When a bound method is passed to the constructor of the Proxy class, it creates a weak reference to the instance and strong references to its class and function definition. Later, when the method is called, it creates a strong method just in time. For all other objects, it acts just like weakref.proxy:

<script src="https://gist.github.com/parente/7077748.js"></script>

---
title: Error Handlers in dojo.Deferred Chains
date: 2011-02-06
---

<a href="http://www.sitepen.com/blog/2010/05/03/robust-promises-with-dojo-deferred-1-5/">Starting in 1.5</a>, Dojo's <a href="http://dojotoolkit.org/api/1.5/dojo/Deferred">Deferred class</a> exposes a `then()` method that accepts three arguments: a success handler for `callback()`, an error handler for `errback`, and a progress handler for `progress()` updates. One interesting feature of the `dojo.Deferred` implementation is the ability of a callback handler to return a new deferred which becomes the target of the next handler scheduled on the original deferred.

Consider these two snippets. The first shows chaining on a single deferred. The second shows chaining with a new deferred returned within the chain.

```javascript
var d1 = functionReturningADeferred();
d1.then(function () {
  console.log("first success");
}).then(function () {
  // scheduled on the same deferred as the first
  // runs if the first handler completes without an exception
  console.log("second success");
});

var d2 = functionReturningADeferred();
d2.then(function () {
  console.log("first success");
  return anotherDeferredReturningFunction();
}).then(function () {
  // scheduled on deferred from anotherDeferredReturningFunction
  // runs when the second deferred's callback is invoked
  console.log("second success");
});
```

<h2>Try #1: Error handlers everywhere</h2>

I recently wrote some code in which my deferred callback handlers returned new deferreds for chaining, but where any deferred in the chain might have its `errback()` invoked. I wanted my handler chain to cease firing after the first occurrence of an error with one and only one handler invoked for that error. I naively started with the following recipe:

```javascript
var d = functionReturningADeferred();
d.then(
  function () {
    console.log("first success");
    return anotherDeferredReturningFunction();
  },
  function () {
    console.log("first error");
  }
)
  .then(
    function () {
      console.log("second success");
      return yetAnotherDeferredReturningFunction();
    },
    function () {
      console.log("second error");
    }
  )
  .then(
    function () {
      console.log("third success");
    },
    function () {
      console.log("third error");
    }
  );
```

To my surprise, when the very first deferred's `errback()` was invoked, the console output declared:

<pre>
  first error
  second success
  third success
</pre>

Likewise, when the second deferred's `errback` was invoked, the console output was:

<pre>
  first success
  second error
  third success
</pre>

I quickly realized my mistake: my error handlers did not return new deferreds. Therefore, each additional `then()` call in my chain registered handlers to be invoked by the success or failure of the previous set in the chain.

<h2>Try #2: Error handlers throwing errors</h2>

I next tried the following approach:

```javascript
var d = functionReturningADeferred();
d.then(
  function () {
    console.log("first success");
    return anotherDeferredReturningFunction();
  },
  function (err) {
    console.log("first error");
    throw err;
  }
)
  .then(
    function () {
      console.log("second success");
      return yetAnotherDeferredReturningFunction();
    },
    function (err) {
      console.log("second error");
      throw err;
    }
  )
  .then(
    function () {
      console.log("third success");
    },
    function (err) {
      console.log("third error");
      throw err;
    }
  );
```

This code showed improvement, but still did not have my desired behavior. An `errback()` on the initial deferred produced the following output:

<pre>
  first error
  second error
  third error
</pre>

An `errback()` on the second showed the following output:

<pre>
  first success
  second error
  third error
</pre>

After a little more thinking, I realized the same problem plaguing my first approach was in effect here. My error handlers were still not returning new deferreds. The chained handlers were still operating on the success or failure conditions of their predecessors.

<h2>Solution: One terminal error handler</h2>

Finally, I hit upon a pattern with the behavior I wanted:

```javascript
var d = functionReturningADeferred();
d.then(function () {
  console.log("first success");
  return anotherDeferredReturningFunction();
})
  .then(function () {
    console.log("second success");
    return yetAnotherDeferredReturningFunction();
  })
  .then(
    function () {
      console.log("third success");
    },
    function (err) {
      console.log("any error");
    }
  );
```

A `errback()` on the first deferred now resulted in the following output:

<pre>
  any error
</pre>

An `errback()` on the second produced in the following:

<pre>
  first success
  any error
</pre>

<h3>Why does it work?</h3>

Any error early in the chain falls through the chain until it reaches an error handler. Placing the error handler at the end of the chain guarantees it and it alone will fire after any `errback()` in the chain.

<h2>Try it yourself</h2>

I created a easy-to-run jsFiddle that demonstrates the second and third patterns mentioned in this post. Let me know if you find any other interesting behaviors.

<iframe style="width: 100%; height: 300px; border: 1px solid gray; margin-top: 1em" src="http://jsfiddle.net/parente/Azh4t/embedded/"></iframe>

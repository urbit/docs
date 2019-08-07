+++
title = "1.6.1 Walkthrough: Ackermann Function"
weight = 14
template = "doc.html"
+++

The Ackermann function is one of the earliest examples of a function that is both totally computable -- meaning that it can be solved -- and not primitively recursive -- meaning it can not be rewritten in an iterative fashion.

In this lesson, we will write a gate that computes the [Ackermann function](https://en.wikipedia.org/wiki/Ackermann_function)

 ```
|=  [m=@ n=@]
?:  =(m 0)  +(n)
?:  =(n 0)  $(m (dec m), n 1)
$(m (dec m), n $(n (dec n)))
```

With the first line, `|=  [m=@ n=@]`, we create a gate that takes two arguments, `m` and `n`, both of the `@` type.



There are three cases.

First, if `m` is zero, return the increment of `n`.
Second, if `n` is zero, decrement `m`, set `n` to 1 and recurse.
Else, decrement `m` and set `n` to be the value of the Ackermann function with `n` and the decrement of `n` as arguments.

This is not a terribly useful function to compute but it has an interesting history in mathematics. When running this function the value grows rapidly even for very small input. The value of computing this where `m` is `4` and `n` is `2` is an integer with 19,729 digits.


### [Next Up: Reading -- Arms and Cores](../arms-and-cores)

+++
title = "Ackermann"
weight = 10
template = "doc.html"
+++

Write a gate to compute [Ackermann's Function](https://en.wikipedia.org/wiki/Ackermann_function)

```
|=  [m=@ n=@]
?~  m  +(n)
?~  n  $(m (dec m), n 1)
$(m (dec m), n $(n (dec n)))
```

Ackermann Function is one of the earliest examples of a function that is totally computable, meaning it can be solved, but is not primitive recursive, meaning it can not be rewritten in an iterative fashion.

Our gate takes two argument, `m` and `n`. There are three cases.

First, if `m` is zero, return the increment of `n`.
Second, if `n` is zero, decrement `m`, set `n` to 1 and recurse.
Else, decrement `m` and set `n` to be the value of the Ackermann function with `n` and the decrement of `n` as arguments.

This is not a terribly useful function to compute but it has an interesting history in mathematics. When running this function the value grows rapidly even for very small input. The value of computing this where `m` is `4` and `n` is `2` is an integer with 19,729 digits.

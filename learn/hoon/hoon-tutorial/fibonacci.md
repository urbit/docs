+++
title = "1.4.1 Walkthrough: Fibonacci Sequence"
weight = 7
template = "doc.html"
+++

In this example, we will write a generator that produces a list of Fibonacci numbers up to `n`.

```hoon
|=  n=@ud
%-  flop
=+  [i=0 p=0 q=1 r=*(list @ud)]
|-  ^+  r
?:  =(i n)  r
%=  $
  i  +(i)
  p  q
  q  (add p q)
  r  [q r]
==
```

On the first line, we use `|=` to produce a gate which takes an `@ud` that's stored in the face `n`. This `n` sample that we give our gate determines how long our Fibonacci sequence is. When the list that our program builds has `n` members, the program ends.

```hoon
%-  flop
```

In the line above, we use `flop` on the output of the rest of the program. `flop` is a standard library function to reverse a list.

Why are we using this instead of just producing the list in the order we want it in the first place? Because with lists, adding an element to the end is a computationally expensive operation that gets more expensive the longer the list is, due to the fact that you need to traverse to the end of the tree. Adding an element to the front, however, is cheap. [In Big-O Notation](https://en.wikipedia.org/wiki/Big_O_notation), adding to the end of a list is O(n) and the front is O(1).

```hoon
=+  [i=0 p=0 q=1 r=*(list @ud)]
```

Here we declare several values that we are going to use the execution of our program. The only one of these that is noteworthy is `r`: we're using `*` to bunt, or get the default value for, the mold `(list @ud)`.

```hoon
|-  ^+  r
```

With this code, we define `|-`, the _trap_ that acts as a recursion point and contains the rest of our program. We also use `^+` to cast the output by example. This will result in the output being the same type as `r`, a list of `@ud`.

```hoon
?:  =(i n)  r
```

In the code above, `?:` checks whether the first child, `=(i n)`, our terminating case, is true or false. If it is true, it branches to `r` and the program ends. If it is false, the program continues to the code below.

```hoon
%=  $
  i  +(i)
  p  q
  q  (add p q)
  r  [q r]
==
```

The final expression in our program calls the `$` arm of the trap we are but makes some changes: we increment `i`, set `p` to be `q` and `q` becomes the sum of `p` and `q`. `r` becomes a cell of `q` and whatever `r` was previously. The list built from this is the one that will get `flop`ped to produce the result at the end of the computation.

### [Next Up: Reading -- Gates](../gates)

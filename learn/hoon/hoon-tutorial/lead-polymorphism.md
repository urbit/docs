+++
title = "2.5.2 Walkthrough: Lead Polymorphism"
weight = 33
template = "doc.html"
+++

There are four kinds of cores: gold, iron, zinc, and lead. You are able to use core-variance rules to create programs which take other programs as arguments. Which particular rules depends on which kind of core your program needs to complete.

Lead cores have opaque payloads. That is, the payload can not be written to or read from. Below is an example of using lead cores. The program produces a list populated by the first 10 elements of `fib`.

```
=<  (to-list (take fib 10))
|%
++  stream
  |*  of=mold
  $_  ^?   |.
  ^-  $@(~ [item=of more=^$])
  ~
++  stream-type
  |*  s=(stream)
  $_  =>  (s)
  ?~  .  !!
  item
++  to-list
  |*  s=(stream)
  %-  flop
  =|  r=(list (stream-type s))
  |-  ^+  r
  =+  (s)
  ?~  -  r
  %=  $
    r  [item r]
    s  more
  ==
++  take
  |*  [s=(stream) n=@]
  =|  i=@
  ^+  s
  |.
  ?:  =(i n)  ~
  =+  (s)
  ?~  -  ~
  :-  item
  %=  ..$
    i  +(i)
    s  more
  ==
++  fib
  ^-  (stream @ud)
  =+  [p=0 q=1]
  |.  :-  q
  %=  .
    p  q
    q  (add p q)
  ==
--
```

There are five arms in this core: `stream`, `stream-type`, `to-list`, `take`, and `fib`.


```
++  stream
  |*  of=mold
  $_  ^?  |.
  ^-  $@(~ [item=of more=^$])
  ~
```

`stream` is a mold-builder. It's a wet gate that takes one argument, `of`, which is a `mold`, and produces a trap -- a function with no argument.

`$_` is a rune that produces a type from an example; `^?` converts (casts) a core to lead; `|.` forms the trap. So to follow this sequence we read it backwards: we create a trap, convert it to a lead trap (making its payload inaccessible), and then use that lead trap as an example to produce a type from.

With the line `^-  $@(~ [item=of more=^$])`, the output of the trap will be cast into a new type. `$@` is the rune to describe a data structure that can either be an atom or a cell. The first part describes the atom, which here is going to be `~`. The second part describes a cell, which we define to have the head of type `of` with the face `item`, and a tail with a face of `more`. The expression `^$` is not a rune, but rather a reference to the enclosing wet gate, so the tail of this cell will be of the same type produced by this wet gate.

The final `~` here is used as the type produced when initially calling this wet gate. This is valid because it nests within the type we defined on the previous line.

Now you can see that a `stream` is either `~` or a pair of a value of some type and a `stream`. This type represents an infinite series.

```
++  stream-type
  |*  s=(stream)
  $_  =>  (s)
  ?~  .  !!
  item
```

`stream-type` is a wet gate that produces the type of items stored in the `stream` arm. The `(stream)` syntax is a shortcut for `(stream *)`; a stream of some type.

Calling a `stream`, which is a trap, will either produce `item` and `more` or it will produce `~`. If it does produce `~`, the `stream` is empty and we can't find what type it is, so we simply crash with `!!`.

```
++  take
  |*  [s=(stream) n=@]
  =|  i=@
  ^+  s
  |.
  ?:  =(i n)  ~
  =+  (s)
  ?~  -  ~
  :-  item
  %=  ..$
    i  +(i)
    s  more
  ==
```

We're going to skip over `to-list` and examine `take` first. `take` is another wet gate. This time it takes a `stream` `s` and an atom `n`. We add an atom to the subject and then make sure that the trap we are creating is going to be of the same type as `s`, the `stream` we passed in.

If `i` and `n` are equal, the trap will produce `~`. Otherwise, `s` is called and has its result put on the front of the subject. If its value is `~`, then the trap again produces `~`. Otherwise the trap produces a cell of `item`, the first part of the value of `s`, and a new trap that increments `i`, and sets `s` to be the `more` trap which produces the next value of the `stream`. The result here is a `stream` that will only ever produce `n` items, even if the stream otherwise would have been infinite.

```
++  to-list
  |*  s=(stream)
  %-  flop
  =|  r=(list (stream-type s))
  |-  ^+  r
  =+  (s)
  ?~  -  r
  %=  $
    r  [item r]
    s  more
  ==
```

Now with that in hand, let's go back to `to-list`. It's also a wet gate that takes `s`, a `stream`, only here it will, as you might expect, produce a `list`. The rest of this wet gate is straightforward, but we can examine it quickly anyway. As is the proper style, this list that is produced will be reversed, so `flop` is used to put it in the order it is in the stream. Recall that adding to the front of a list is cheap, while adding to the back is expensive.

`r` is added to the subject as an empty `list` of whatever type is produced by `s`. A new trap is formed and called, and it will produce the same type as `r`. Then `s` is called and has its value added to the subject. If the result is `~`, the trap produces `r`. Otherwise, we want to call the trap again, adding `item` to the front of `r` and changing `s` to `more`. Now the utility of `take` should be clear. We don't want to feed `to-list` an infinite stream as it would never terminate.

```
++  fib
  ^-  (stream @ud)
  =+  [p=0 q=1]
  |.  :-  q
  %=  .
    p  q
    q  (add p q)
  ==
```

The final arm in our core is `fib`, which is a `stream` of `@ud` and therefore an iron core. It's subject contains `p` and `q`, which will not be accessible outside of this trap. The product of the trap is a pair of an `@ud` and the trap that will produce the next `@ud` in the Fibonacci series.


```
=<  (to-list (take fib 10))
```

Finally, the first line of our program will take the first 10 elements of `fib` and produce them as a list.

```
~[1 1 2 3 5 8 13 21 34 55]
```

This example is a bit overkill for simply calculating the Fibonacci series, but it nicely illustrates how you might use iron cores. Instead of `fib`, you could have any `stream` that produces some stream of values and you'd still be able to use the `take`, `to-list`, and `stream-type` arms.

[Next Up: Reading -- Gall](../gall)

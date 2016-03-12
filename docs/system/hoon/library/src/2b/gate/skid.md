### `++skid`

Separate

Separates a [`++list`]() `a` into two lists - Those elements of `a` who produce
true when slammed to [gate]() `b` and those who produce `%.n`.

Accepts
-------

`b` is a gate that accepts one argument and produces a loobean.

Produces
--------

A cell of two lists.

Source
------

    ++  skid                                                ::  separate
      |*  [a=(list) b=$+(* ?)]
      |-  ^+  [p=a q=a]
      ?~  a  [~ ~]
      =+  c=$(a t.a)
      ?:((b i.a) [[i.a p.c] q.c] [p.c [i.a q.c]])


Examples
--------

    ~zod/try=> =a |=(a=@ (gth a 1))
    ~zod/try=> (skid (limo [0 1 2 3 ~]) a)
    [p=[i=2 t=[i=3 t=~]] q=[i=0 t=[i=1 t=~]]]



***

### `++skip`

Except

Cycles through the members of `++list` `a`, passing them to a gate `b`. 
Produces a list of all of the members that produce `%.n`. Inverse of
`++skim`.

Accepts
-------

`b` is a gate that accepts one argument and produces a loobean.

Produces
--------

A list of the same type as `a`.

Source
------

    ++  skip                                                ::  except
      ~/  %skip
      |*  {a/(list) b/$-(* ?)}
      |-
      ^+  a
      ?~  a  ~
      ?:((b i.a) $(a t.a) [i.a $(a t.a)])


Examples
--------

    ~zod/try=> =a |=(a/@ (gth a 1))
    ~zod/try=> (skip (limo [0 1 2 3 ~]) a)
    [i=0 t=[i=1 t=~]]



***

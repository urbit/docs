### `++skim`

Suffix

Cycles through the members of a list `a`, passing them to a gate `b` and
producing a list of all of the members that produce `%.y`. Inverse of
`++skip`.

Accepts
-------

`b` is a [gate]() that accepts one argument and produces a loobean.

Produces
--------

Source
------

++  skim                                                ::  only
  ~/  %skim
  |*  [a=(list) b=_|=(p=* .?(p))]
  |-
  ^+  a`
  ?~  a  ~
  ?:((b i.a) [i.a $(a t.a)] $(a t.a))

Examples
--------

    ~zod/try=> =a |=(a=@ (gth a 1))
    ~zod/try=> (skim (limo [0 1 2 3 ~]) a)
    [i=2 t=[i=3 t=~]]



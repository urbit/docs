### `++gte`

Greater-than/equal

Tests whether `a` is greater than a number `b`.

Accepts
-------

`a` is an [atom]().

`b` is an atom.

Produces
--------

A boolean.

Source
------

    ++  gte                                                 ::  greater-equal
      ~/  %gte
      |=  [a=@ b=@]
      ^-  ?
      !(lth a b)
    ::

Examples
--------

    ~zod/try=> (gte 100 10)
    %.y
    ~zod/try=> (gte 4 4)
    %.y
    ~zod/try=> (gte 3 4)
    %.n



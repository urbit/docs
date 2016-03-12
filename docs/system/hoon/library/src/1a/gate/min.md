### `++min`

Minimum

Computes the lesser of `a` and `b`.

Accepts
-------

`a` is an [atom]().

`b` is an atom.

Produces
--------

An atom.

Source
------

    ++  min                                                 ::  minimum
      ~/  %min
      |=  [a=@ b=@]
      ^-  @
      ?:  (lth a b)  a
      b
    ::

Examples
--------

    ~zod/try=> (min 10 100)
    10
    ~zod/try=> (min 10.443 9)
    9
    ~zod/try=> (min 0 1)
    0



***

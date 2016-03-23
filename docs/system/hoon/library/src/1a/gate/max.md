### `++max`

Maximum

Computes the greater of `a` and `b`.

Accepts
-------

`a` is an atom.

`b` is an atom.

Produces
--------

An atom.

Source
------

    ++  max                                                 ::  maximum
      ~/  %max
      |=  {a/@ b/@}
      ^-  @
      ?:  (gth a b)  a
      b

Examples
--------

    ~zod/try=> (max 10 100)
    100
    ~zod/try=> (max 10.443 9)
    10.443
    ~zod/try=> (max 0 1)
    1



***

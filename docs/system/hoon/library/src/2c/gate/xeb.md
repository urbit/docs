### `++xeb`

Binary logarithm

Computes the base-2 logarithm of `a`, producing an atom.

Accepts
-------

`a` is an atom.

Produces
--------

An atom.

Source
------

    ++  xeb                                                 ::  binary logarithm
      ~/  %xeb
      |=  a/@
      ^-  @
      (met 0 a)

Examples
--------

    ~zod/try=> (xeb 31)
    5
    ~zod/try=> (xeb 32)
    6
    ~zod/try=> (xeb 49)
    6
    ~zod/try=> (xeb 0)
    0
    ~zod/try=> (xeb 1)
    1
    ~zod/try=> (xeb 2)
    2



***

### `++lte`

Less-than/equal

Tests whether `a` is less than or equal to `b`.

Accepts
-------

`a` is an atom.

`b` is an atom.

Produces
--------

A boolean.

Source
------

    ++  lte                                                 ::  less-equal
      ~/  %lte
      |=  {a/@ b/@}
      |(=(a b) (lth a b))

    ::

Examples
--------

    ~zod/try=> (lte 4 5)
    %.y
    ~zod/try=> (lte 5 4)
    %.n
    ~zod/try=> (lte 5 5)
    %.y
    ~zod/try=> (lte 0 0)
    %.y



***

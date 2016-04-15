### `++gth`

Greater-than

Tests whether `a` is greater than `b`.

Accepts
-------

`a` is an atom.

`b` is an atom.

Produces
--------

A boolean.

Source
------

    ++  gth                                                 ::  greater-than
      ~/  %gth
      |=  {a/@ b/@}
      ^-  ?
      !(lte a b)



Examples
--------

    ~zod/try=> (gth 'd' 'c')
    %.y
    ~zod/try=> (gth ~h1 ~m61)
    %.n



***

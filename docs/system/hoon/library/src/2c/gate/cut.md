### `++cut`

Slice

Slices `c` blocks of size `a` that are `b` blocks from the end of `d`.

Accepts
-------

`a` is a block size (see ++bloq).

`b` is an atom.

`c` is an atom.

Produces
--------

An atom.

Source
------

    ++  cut                                                 ::  slice
      ~/  %cut
      |=  {a/bloq {b/@u c/@u} d/@}
      (end a c (rsh a b d))

Examples
--------

    ~zod/try=> (cut 0 [1 1] 2)
    1
    ~zod/try=> (cut 0 [2 1] 4)
    1
    ~zod/try=> `@t`(cut 3 [0 3] 'abcdefgh')
    'abc'
    ~zod/try=> `@t`(cut 3 [1 3] 'abcdefgh')
    'bcd'
    ~zod/try=> `@ub`(cut 0 [0 3] 0b1111.0000.1101)
    0b101
    ~zod/try=> `@ub`(cut 0 [0 6] 0b1111.0000.1101)
    0b1101
    ~zod/try=> `@ub`(cut 0 [4 6] 0b1111.0000.1101)
    0b11.0000
    ~zod/try=> `@ub`(cut 0 [3 6] 0b1111.0000.1101)
    0b10.0001



***

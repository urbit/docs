### `++rsh`

Right-shift

Right-shifts `c` by `b` blocks of size `a`, producing an [atom]().

Accepts
-------

`a` is a block size (see [`++bloq`]()).

`b` is an atom.

`c` is an atom.

Produces
--------

An atom.

Source
------

    ++  rsh                                                 ::  right-shift
      ~/  %rsh
      |=  [a=bloq b=@ c=@]
      (div c (bex (mul (bex a) b)))

Examples
--------

    ~zod/try=> `@ub`145
    0b1001.0001
    ~zod/try=> `@ub`(rsh 1 1 145)
    0b10.0100
    ~zod/try=> (rsh 1 1 145)
    36
    ~zod/try=> `@ub`(rsh 2 1 145)
    0b1001
    ~zod/try=> (rsh 2 1 145)
    9
    ~zod/try=> `@ub`10
    0b1010
    ~zod/try=> `@ub`(rsh 0 1 10)
    0b101
    ~zod/try=> (rsh 0 1 10)
    5
    ~zod/try=> `@ux`'abc'
    0x63.6261
    ~zod/try=> `@t`(rsh 3 1 'abc')
    'bc'
    ~zod/try=> `@ux`(rsh 3 1 'abc')
    0x6362



### `++lsh`

Left-shift

Produces an [atom]() by left-shifting `c` by `b` blocks of size `a`.

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

    ++  lsh                                                 ::  left-shift
      ~/  %lsh
      |=  [a=bloq b=@ c=@]
      (mul (bex (mul (bex a) b)) c)

Examples
--------

    ~zod/try=> `@ub`1
    0b1
    ~zod/try=> `@ub`(lsh 0 1 1)
    0b10
    ~zod/try=> (lsh 0 1 1)
    2
    ~zod/try=> `@ub`255
    0b1111.1111
    ~zod/try=> `@ub`(lsh 3 1 255)
    0b1111.1111.0000.0000
    ~zod/try=> (lsh 3 1 255)
    65.280



***

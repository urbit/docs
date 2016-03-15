### `++not`

Binary NOT

Computes the bit-wise logical NOT of the bottom `b` blocks of size `a`
of `c`.

Accepts
-------

`a` is a block size (see `++bloq`).

`b` is an atom.

`c` is an atom.

Produces
--------

An atom. 

Source
------

    ++  not  |=  {a/bloq b/@ c/@}                           ::  binary not (sized)
      (mix c (dec (bex (mul b (bex a)))))


Examples
--------

    ~zod/try=> `@ub`24
    0b1.1000
    ~zod/try=> (not 0 5 24)
    7
    ~zod/try=> `@ub`7
    0b111
    ~zod/try=> (not 2 5 24)
    1.048.551
    ~zod/try=> (not 2 5 1.048.551)
    24
    ~zod/try=> (not 1 1 (not 1 1 10))
    10



***

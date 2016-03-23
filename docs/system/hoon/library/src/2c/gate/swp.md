### `++swp`

Reverse block order

Switches little endian to big and vice versa: produces an atom by
reversing the block order of `b` using block size `a`.


Accepts
-------

`a` is a block size (see `++bloq`).

`b` is an atom.

Produces
--------

An atom

Source
------

    ++  swap  |=({a/bloq b/@} (rep a (flop (rip a b))))     ::  reverse bloq order

Examples
--------

    ~zod/try=> `@ub`24
    0b1.1000
    ~zod/try=> (swap 0 24)
    3
    ~zod/try=> `@ub`3
    0b11
    ~zod/try=> (swap 0 0)
    0
    ~zod/try=> (swap 0 128)
    1



***

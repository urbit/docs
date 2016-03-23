### `++rip`

Disassemble

Produces a list of atoms from the bits of `b` using block size `a`.

Accepts
-------

`a` is a block size (see `++bloq`).

`b` is an atom.

Produces
--------

A list of atoms.

Source
------

    ++  rip                                                 ::  disassemble
      ~/  %rip
      |=  {a/bloq b/@}
      ^-  (list @)
      ?:  =(0 b)  ~
      [(end a 1 b) $(b (rsh a 1 b))]

Examples
--------

    ~zod/try=> `@ub`155
    0b1001.1011
    ~zod/try=> (rip 0 155)
    ~[1 1 0 1 1 0 0 1]
    ~zod/try=> (rip 2 155)
    ~[11 9]
    ~zod/try=> (rip 1 155)
    ~[3 2 1 2]
    ~zod/try=> `@ub`256
    0b1.0000.0000
    ~zod/try=> (rip 0 256)
    ~[0 0 0 0 0 0 0 0 1]
    ~zod/try=> (rip 2 256)
    ~[0 0 1]
    ~zod/try=> (rip 3 256)
    ~[0 1]



***

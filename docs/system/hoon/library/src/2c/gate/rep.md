### `++rep`

Assemble single

Produces an [atom]() by assembling a list of atoms `b` using block size `a`.

Accepts
-------

`a` is a block size (see [`++bloq`]()).

`b` is a list of atoms.

Produces
--------

An atom.

Source
------

    ++  rep                                                 ::  assemble single
      ~/  %rep
      |=  [a=bloq b=(list ,@)]
      ^-  @
      =+  c=0
      |-
      ?~  b  0
      (con (lsh a c (end a 1 i.b)) $(c +(c), b t.b))

Examples
--------

    ~zod/try=> `@ub`(rep 2 (limo [1 2 3 4 ~]))
    0b100.0011.0010.0001
    ~zod/try=> (rep 0 (limo [0 0 1 ~]))
    4
    ~zod/try=> (rep 0 (limo [0 0 0 1 ~]))
    8
    ~zod/try=> (rep 0 (limo [0 1 0 0 ~]))
    2
    ~zod/try=> (rep 0 (limo [0 1 0 1 ~]))
    10
    ~zod/try=> (rep 0 (limo [0 1 0 1 0 1 ~]))
    42
    ~zod/try=> `@ub`42
    0b10.1010



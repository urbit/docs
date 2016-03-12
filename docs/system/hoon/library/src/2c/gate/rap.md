### `++rap`

Assemble non-zero

Concatenates a list of [atom]()s `b` using blocksize `a`, producing an atom.

Accepts
-------

`a` is a block size (see [`++bloq`]()).

`b` is a [`++list`]() of [atom]()s.

Produces
--------

An atom.

Source
------

    ++  rap                                                 ::  assemble nonzero
      ~/  %rap
      |=  [a=bloq b=(list ,@)]
      ^-  @
      ?~  b  0
      (cat a i.b $(b t.b))

Examples
--------

    ~zod/try=> `@ub`(rap 2 (limo [1 2 3 4 ~]))
    0b100.0011.0010.0001
    ~zod/try=> `@ub`(rap 1 (limo [1 2 3 4 ~]))
    0b1.0011.1001
    ~zod/try=> (rap 0 (limo [0 0 0 ~]))
    0
    ~zod/try=> (rap 0 (limo [1 0 1 ~]))
    3



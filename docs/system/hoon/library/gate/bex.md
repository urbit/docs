### `++bex`

Binary exponent

Computes the result of `2^a`, producing an [atom]().

Accepts
-------

`a` is an atom.

Produces
--------

An atom.

Source
------

    ++  bex                                                 ::  binary exponent
      ~/  %bex
      |=  a=@
      ^-  @
      ?:  =(0 a)  1
      (mul 2 $(a (dec a)))

Examples
--------

    ~zod/try=> (bex 4)
    16
    ~zod/try=> (bex (add 19 1))
    1.048.576
    ~zod/try=> (bex 0)
    1



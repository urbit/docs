### `++peg`

Axis within axis

Computes the axis of `b` within axis `a`.

Accepts
-------

`a` is an [atom]().

`b` is an atom.

Produces
--------

An atom.

Source
------

    ++  peg                                                 ::  tree connect
      ~/  %peg
      |=  [a=@ b=@]
      ^-  @
      ?-  b
        1   a
        2   (mul a 2)
        3   +((mul a 2))
        *   (add (mod b 2) (mul $(b (div b 2)) 2))
      ==
    ::

Examples
--------

    ~zod/try=>  (peg 4 1)
    4
    ~zod/try=>  (peg 4 2)
    8
    ~zod/try=>  (peg 8 45)
    269



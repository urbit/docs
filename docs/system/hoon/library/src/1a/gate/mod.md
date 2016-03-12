### `++mod`

Modulus

Computes the remainder of dividing `a` by `b`.

Accepts
-------

`a` is an [atom]().

`b` is an atom.

Produces
--------

An atom.

Source
------

    ++  mod                                                 ::  remainder
      ~/  %mod
      |=  [a=@ b=@]
      ^-  @
      ?<  =(0 b)
      (sub a (mul b (div a b)))
    ::

Examples
--------

    ~zod/try=> (mod 5 2)
    1
    ~zod/try=> (mod 5 5)
    0



***

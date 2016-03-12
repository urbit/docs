### `++add`

Add

Produces the sum of `a` and `b`.

Accepts
-------

`a` is an [atom]().

`b` is an atom.

Produces
--------

An atom.

Source
------

    ++  add                                                 ::  add
      ~/  %add
      |=  [a=@ b=@]
      ^-  @
      ?:  =(0 a)  b
      $(a (dec a), b +(b))

Examples
--------

    ~zod/try=> (add 2 2)
    4
    ~zod/try=> (add 1 1.000.000)
    1.000.001
    ~zod/try=> (add 1.333 (mul 2 2))
    1.337



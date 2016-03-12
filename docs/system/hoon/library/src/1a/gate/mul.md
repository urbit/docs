### `++mul`

Multiply

Multiplies `a` by `b`.

Accepts
-------

`a` is an [atom]().

`b` is an atom.

Produces
--------

An atom.

Source
------

    ++  mul                                                 ::  multiply
      ~/  %mul
      |=  [a=@ b=@]
      ^-  @
      =+  c=0
      |-
      ?:  =(0 a)  c
      $(a (dec a), c (add b c))
    ::

Examples
--------

    ~zod/try=> (mul 3 4)
     12 
    ~zod/try=> (mul 0 1) 
    0



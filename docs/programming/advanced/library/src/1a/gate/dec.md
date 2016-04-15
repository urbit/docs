### `++dec`

Decrement

Decrements `a` by `1`.

Accepts
-------

`a` is an atom.

Produces
--------

An atom.

Source
------

    ++  dec                                                 ::  decrement
      ~/  %dec
      |=  a/@
      ~|  %decrement-underflow
      ?<  =(0 a)
      =+  b=0
      |-  ^-  @
      ?:  =(a +(b))  b
      $(b +(b))

Examples
--------

    ~zod/try=> (dec 7)
    6
    ~zod/try=> (dec 0)
    ! decrement-underflow
    ! exit



***

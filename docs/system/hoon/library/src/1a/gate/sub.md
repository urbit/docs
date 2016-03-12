### `++sub`

Subtract

Subtracts `b` from `a`.

Accepts
-------

`a` is an [atom]().

`b` is an [atom]().

Produces
--------

An atom.

Source
------

    ++  sub                                                 ::  subtract
      ~/  %sub
      |=  [a=@ b=@]
      ~|  %subtract-underflow
      ^-  @
      ?:  =(0 b)  a
      $(a (dec a), b (dec b))

Examples
--------

    ~zod/try=> (sub 10 5)
    5
    ~zod/try=> (sub 243 44)
    199
    ~zod/try=> (sub 5 0)
    5
    ~zod/try=> (sub 0 5)
    ! subtract-underflow
    ! exit



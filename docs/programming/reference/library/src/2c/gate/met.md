### `++met`

Measure

Computes the number of blocks of size `a` in `b`, producing an atom.

`a` is a block size (see `++bloq`).

`b` is an atom.

Source
------

    ++  met                                                 ::  measure
      ~/  %met
      |=  {a/bloq b/@}
      ^-  @
      =+  c=0
      |-
      ?:  =(0 b)  c
      $(b (rsh a 1 b), c +(c))

Examples
--------

    ~zod/try=> (met 0 1)
    1
    ~zod/try=> (met 0 2)
    2
    ~zod/try=> (met 3 255)
    1
    ~zod/try=> (met 3 256)
    2
    ~zod/try=> (met 3 'abcde')
    5



***

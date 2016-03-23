### `++div`

Divide

Computes `a` divided by `b`.

Accepts
-------

`a` is an atom.

`b` is an atom.

Produces
--------

An atom.

Source
------

    ++  div                                                 ::  divide
      ~/  %div
      |=  [a=@ b=@]
      ^-  @
      ~|  'div'
      ?<  =(0 b)
      =+  c=0
      |-
      ?:  (lth a b)  c
      $(a (sub a b), c +(c))
    ::

Examples
--------

    ~zod/try=> (div 4 2)
    2
    ~zod/try=> (div 17 8)
    2
    ~zod/try=> (div 20 30)
    0


***

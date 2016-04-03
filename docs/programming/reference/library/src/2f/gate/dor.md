### `++dor`

Numeric order

Computes whether `a` and `b` are in ascending numeric order, producing a
boolean.

Accepts
-------

`a` is a noun.

`b` is a noun.

Produces
--------

A boolean atom.

Source
------

    ++  dor                                                 ::  d-order
      ~/  %dor
      |=  {a/* b/*}
      ^-  ?
      ?:  =(a b)  &
      ?.  ?=(@ a)
        ?:  ?=(@ b)  |
        ?:  =(-.a -.b)
          $(a +.a, b +.b)
        $(a -.a, b -.b)
      ?.  ?=(@ b)  &
      (lth a b)


Examples
--------

    ~zod/try=> (dor 1 2)
    %.y
    ~zod/try=> (dor 2 1)
    %.n
    ~zod/try=> (dor ~[1 2 3] ~[1 2 4])
    %.y
    ~zod/try=> (dor ~[1 2 4] ~[1 2 3])
    %.n
    ~zod/try=> (dor (limo ~[99 100 10.000]) ~[99 101 10.000])
    %.y
    ~zod/try=> (dor ~[99 101 10.999] (limo ~[99 100 10.000]))
    %.n



***

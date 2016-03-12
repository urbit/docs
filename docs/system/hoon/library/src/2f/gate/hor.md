### `++hor`

Hash order

XX revisit

Recursive hash comparator gate.

Accepts
-------

`a` is a [noun]().

`b` is a noun.

Produces
--------

A boolean [atom](). 


Source
------

    ++  hor                                                 ::  h-order
      ~/  %hor
      |=  [a=* b=*]
      ^-  ?
      ?:  ?=(@ a)
        ?.  ?=(@ b)  &
        (gor a b)
      ?:  ?=(@ b)  |
      ?:  =(-.a -.b)
        (gor +.a +.b)
      (gor -.a -.b)

Examples
--------

    ~zod/try=> (hor . 1)
    %.n
    ~zod/try=> (hor 1 2)
    %.y
    ~zod/try=> (hor "abc" "cba")
    %.y
    ~zod/try=> (hor 'c' 'd')
    %.n



***

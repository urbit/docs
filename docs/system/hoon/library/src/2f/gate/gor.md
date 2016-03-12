### `++gor`

Hash order

XX revisit

Accepts
-------

`a` is a [noun]().

`b` is a noun.

Produces
--------

A boolean [atom]().

Source
------

    ++  gor                                                 ::  g-order
      ~/  %gor
      |=  [a=* b=*]
      ^-  ?
      =+  [c=(mug a) d=(mug b)]
      ?:  =(c d)
        (dor a b)
      (lth c d)

Examples
--------

    ~zod/try=> (gor 'd' 'c')
    %.y
    ~zod/try=> 'd'
    'd'
    ~zod/try=> 'c'
    ~zod/try=> `@ud`'d'
    100
    ~zod/try=> `@ud`'c'
    99
    ~zod/try=> (mug 'd')
    1.628.185.714
    ~zod/try=> (mug 'c')
    1.712.073.811
    ~zod/try=> (gor 'd' 'c')
    %.y
    ~zod/try=> (gor 'c' 'd')
    %.n
    ~zod/try=> (gor "foo" "bar")
    %.n
    ~zod/try=> (gor (some 10) (limo [1 2 3 ~]))
    %.n



***

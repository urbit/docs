### `++vor`

Double hash comparator gate.

XX revisit

Accepts
-------

`a` is a [noun]()

`b` is a noun

Produces
-------

Source
------

    ++  vor                                                 ::  v-order
      ~/  %vor
      |=  [a=* b=*]
      ^-  ?
      =+  [c=(mug (mug a)) d=(mug (mug b))]
      ?:  =(c d)
        (dor a b)
      (lth c d)

Examples
--------

    ~zod/try=> (vor 'f' 'g')
    %.y
    ~zod/try=> (vor 'a' 'z')
    %.n
    ~zod/try=> (vor 43.326 41.106)
    %.n



***

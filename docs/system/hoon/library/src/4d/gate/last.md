### `++last`

Farther trace

Compares two line-column pairs, called `++hair`s, `zyc` and `naz`, producing whichever
is further along.

Accepts
-------

`naz` is a hair.

`zyc` is a hair.

Produces
--------

a `++hair`.

Source
------

    ++  last  |=  {zyc/hair naz/hair}                       ::  farther trace
              ^-  hair
              ?:  =(p.zyc p.naz)
                ?:((gth q.zyc q.naz) zyc naz)
              ?:((gth p.zyc p.naz) zyc naz)


Examples
--------

    ~zod/try=> (last [1 1] [1 2])
    [p=1 q=2]
    ~zod/try=> (last [2 1] [1 2])
    [p=2 q=1]
    ~zod/try=> (last [0 0] [99 0])
    [p=99 q=0]
    ~zod/try=> (last [7 7] [7 7])
    [p=7 q=7]


***

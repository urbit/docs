### `++next`

Consume char

Consume any character, producing it as a result.

Accepts
-------

`tub` is a [`++nail`]()

Produces
--------

An [`++edge`]().

Source
------

    ++  next                                                ::  consume a char
      |=  tub=nail
      ^-  (like char)
      ?~  q.tub
        (fail tub)
      =+  zac=(lust i.q.tub p.tub)
      [zac [~ i.q.tub [zac t.q.tub]]]
    ::

Examples
--------

    ~zod/try=> (next [[1 1] "ebc"])
    [p=[p=1 q=2] q=[~ [p=~~e q=[p=[p=1 q=2] q="bc"]]]] 
    ~zod/try=> (next [[1 1] "john jumps jones"])
    [p=[p=1 q=2] q=[~ [p=~~j q=[p=[p=1 q=2] q="ohn jumps jones"]]]]



***

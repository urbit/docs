### `++like`

Mold generator for an edge

`++like` generates an `++edge` with a parsed result set to a specific type.

Source
------

        ++  like  |*  a=_,*                                     ::  generic edge
              ?@  +.b  ~                                    ::
              :-  ~                                         ::
              u=[p=(a +>-.b) q=[p=(hair -.b) q=(tape +.b)]] ::

Examples
--------
    ~zod/try=> *(like char)
    [p=[p=0 q=0] q=~]

    ~zod/try=> (ace [1 1] " a")
    [p=[p=1 q=2] q=[~ [p=~~. q=[p=[p=1 q=2] q="a"]]]]
    ~zod/try=> `(like char)`(ace [1 1] " a")
    [p=[p=1 q=2] q=[~ [p=~~. q=[p=[p=1 q=2] q="a"]]]]
    ~zod/try=> `(like ,@)`(ace [1 1] " a")
    [p=[p=1 q=2] q=[~ [p=32 q=[p=[p=1 q=2] q="a"]]]]



***

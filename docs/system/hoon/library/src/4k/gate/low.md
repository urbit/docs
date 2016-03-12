### `++low`

Lowercase

Parse a single lowercase letter.

Source
------

    ++  low  (shim 'a' 'z')                                 ::  lowercase

Examples
--------

        ~zod/try=> (scan "g" low)
        ~~g
        ~zod/try=> `cord`(scan "g" low)
        'g'
        ~zod/try=> (scan "abcdefghijklmnopqrstuvwxyz" (star low))
        "abcdefghijklmnopqrstuvwxyz"
        ~zod/try=> (low [[1 1] "g"])
        [p=[p=1 q=2] q=[~ [p=~~g q=[p=[p=1 q=2] q=""]]]]



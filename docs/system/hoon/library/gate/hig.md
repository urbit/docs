### `++hig`

Uppercase

Parse a single uppercase letter.

Source
------

    ++  hig  (shim 'A' 'Z')                                 ::  uppercase

Examples
--------

        ~zod/try=> (scan "G" hig)
        ~~~47.
        ~zod/try=> `cord`(scan "G" hig)
        'G'
        ~zod/try=> (scan "ABCDEFGHIJKLMNOPQRSTUVWXYZ" (star hig))
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        ~zod/try=> (hig [[1 1] "G"])
        [p=[p=1 q=2] q=[~ [p=~~~47. q=[p=[p=1 q=2] q=""]]]]



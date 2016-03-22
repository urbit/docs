### `++mes`

Hexbyte

Parse a hexbyte.

Source
------

    ++  mes  %+  cook                                       ::  hexbyte
               |=({a/@ b/@} (add (mul 16 a) b))
             ;~(plug hit hit)

Examples
--------

        ~zod/try=> (scan "2A" mes)
        42
        ~zod/try=> (mes [[1 1] "2A"])
        [p=[p=1 q=3] q=[~ u=[p=42 q=[p=[p=1 q=3] q=""]]]]
        ~zod/try=> (scan "42" mes)
        66



***

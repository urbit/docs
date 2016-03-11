
### `++nud`

Numeric

Parse a numeric character - A number.

Source
------

    ++  nud  (shim '0' '9')                                 ::  numeric

Examples
--------

    ~zod/try=> (scan "0" nud)
    ~~0
    ~zod/try=> (scan "7" nud)
    ~~7
    ~zod/try=> (nud [[1 1] "1"])
    [p=[p=1 q=2] q=[~ [p=~~1 q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (scan "0123456789" (star nud))
    "0123456789"


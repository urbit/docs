### `++buc`

Parse dollar sign

Parses ASCII character 36, the dollar sign.

Source
------

    ++  buc  (just '$')

Examples
--------

    ~zod/try=> (scan "$" buc)
    ~~~24.
    ~zod/try=> `cord`(scan "$" buc)
    '$'
    ~zod/try=> (buc [[1 1] "$"])
    [p=[p=1 q=2] q=[~ [p=~~~24. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (buc [[1 1] "$%"])
    [p=[p=1 q=2] q=[~ [p=~~~24. q=[p=[p=1 q=2] q="%"]]]]



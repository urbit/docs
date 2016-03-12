### `++tis`

Parse equals sign

Parses ASCII character 61, the equals sign.

Source
------

    ++  tis  (just '=')

Examples
--------

    ~zod/try=> (scan "=" tis)
    ~~~3d.
    ~zod/try=> `cord`(scan "=" tis)
    '='
    ~zod/try=> (tis [[1 1] "="])
    [p=[p=1 q=2] q=[~ [p=~~~3d. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (tis [[1 1] "|="])
    [p=[p=1 q=1] q=~]



***

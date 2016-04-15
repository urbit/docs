### `++dot`

Parse period

Parses ASCII character 46, the period.

Source
------

    ++  dot  (just '.')

Examples
--------

    ~zod/try=> (scan "." dot)
    ~~~.
    ~zod/try=> `cord`(scan "." dot)
    '.'
    ~zod/try=> (dot [[1 1] "."])
    [p=[p=1 q=2] q=[~ [p=~~~. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (dot [[1 1] ".^"])
    [p=[p=1 q=2] q=[~ [p=~~~. q=[p=[p=1 q=2] q="^"]]]]



***

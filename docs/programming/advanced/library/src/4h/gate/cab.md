### `++cab`

Parse underscore

Parses ASCII character 95, the underscore.

Source
------

    ++  cab  (just '_')

Examples
--------

    ~zod/try=> (scan "_" cab)
    ~~~5f.
    ~zod/try=> `cord`(scan "_" cab)
    '_'
    ~zod/try=> (cab [[1 1] "_"])
    [p=[p=1 q=2] q=[~ [p=~~~5f. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (cab [[1 1] "|_"])
    [p=[p=1 q=1] q=~]



***

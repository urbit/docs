### `++col`

Parse colon

Parses ASCII character 58, the colon

Source
------

    ++  col  (just ':')

Examples
--------

    ~zod/try=> (scan ":" col)
    ~~~3a.
    ~zod/try=> `cord`(scan ":" col)
    ':'
    ~zod/try=> (col [[1 1] ":"])
    [p=[p=1 q=2] q=[~ [p=~~~3a. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (col [[1 1] ":-"])
    [p=[p=1 q=2] q=[~ [p=~~~3a. q=[p=[p=1 q=2] q="-"]]]]



### `++com`

Parse comma

Parses ASCII character 44, the comma.

Source
------

    ++  com  (just ',')

Examples
--------

    ~zod/try=> (scan "," com)
    ~~~2c.
    ~zod/try=> `cord`(scan "," com)
    ','
    ~zod/try=> (com [[1 1] ","])
    [p=[p=1 q=2] q=[~ [p=~~~2c. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (com [[1 1] "not com"])
    [p=[p=1 q=1] q=~]



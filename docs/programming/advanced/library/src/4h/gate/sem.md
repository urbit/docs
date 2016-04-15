### `++sem`

Parse semicolon

Parses ASCII character 59, the semicolon.

Source
------

    ++  sem  (just ';')

Examples
--------

    ~zod/try=> (scan ";" sem)
    ~~~3b.
    ~zod/try=> `cord`(scan ";" sem)
    ';'
    ~zod/try=> (sem [[1 1] ";"])
    [p=[p=1 q=2] q=[~ [p=~~~3b. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (sem [[1 1] " ;"])
    [p=[p=1 q=1] q=~]



***

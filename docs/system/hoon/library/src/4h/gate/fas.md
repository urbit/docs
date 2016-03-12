### `++fas`

Parse forward slash

Parses ASCII character 47, the forward slash.

Source
------

    ++  fas  (just '/')

Examples
--------

    ~zod/try=> (scan "/" fas)
    ~~~2f.
    ~zod/try=> `cord`(scan "/" fas)
    '/'
    ~zod/try=> (fas [[1 1] "/"])
    [p=[p=1 q=2] q=[~ [p=~~~2f. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (fas [[1 1] "|/"])
    [p=[p=1 q=1] q=~]



***

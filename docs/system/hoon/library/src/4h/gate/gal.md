### `++gal`

Parse less-than sign

Parses ASCII character 60, the less-than sign.

Source
------

    ++  gal  (just '<')

Examples
--------

    ~zod/try=> (scan "<" gal)
    ~~~3c.
    ~zod/try=> `cord`(scan "<" gal)
    '<'
    ~zod/try=> (gal [[1 1] "<"])
    [p=[p=1 q=2] q=[~ [p=~~~3c. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (gal [[1 1] "<+"])
    [p=[p=1 q=2] q=[~ [p=~~~3c. q=[p=[p=1 q=2] q="+"]]]]
    ~zod/try=> (gal [[1 1] "+<"])
    [p=[p=1 q=1] q=~]



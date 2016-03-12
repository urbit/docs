### `++ser`

Parse right square bracket

Parses ASCII character 93, the right square bracket.

Source
------

    ++  ser  (just ']')

Examples
--------

    ~zod/try=> (scan "]" ser)
    ~~~5d.
    ~zod/try=> `cord`(scan "]" ser)
    ']'
    ~zod/try=> (ser [[1 1] "]"])
    [p=[p=1 q=2] q=[~ [p=~~~5d. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (ser [[1 1] "[ ]"])
    [p=[p=1 q=1] q=~]



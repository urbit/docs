### `++gar`

Parse greater-than sign

Parses ASCII character 62, the greater-than sign.

Source
------

    ++  gar  (just '>')

Examples
--------

    ~zod/try=> (scan ">" gar)
    ~~~3e.
    ~zod/try=> `cord`(scan ">" gar)
    '>'
    ~zod/try=> (gar [[1 1] ">"])
    [p=[p=1 q=2] q=[~ [p=~~~3e. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (gar [[1 1] "=>"])
    [p=[p=1 q=1] q=~]



***

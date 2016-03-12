### `++wut`

Parses question mark

Parses ASCII character 63, the question mark.

Source
------

    ++  wut  (just '?')

Examples
--------

    ~zod/try=> (scan "?" wut)
    ~~~3f.
    ~zod/try=> `cord`(scan "?" wut)
    '?'
    ~zod/try=> (wut [[1 1] "?"])
    [p=[p=1 q=2] q=[~ [p=~~~3f. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (wut [[1 1] ".?"])
    [p=[p=1 q=1] q=~]



***

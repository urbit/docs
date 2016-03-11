### `++ace`

Parse space

Parses ASCII character 32, space.

Source
------

    ++  ace  (just ' ')

Examples
--------

    ~zod/try=> (scan " " ace)
    ~~. 
    ~zod/try=> `cord`(scan " " ace)
    ' '
    ~zod/try=> (ace [[1 1] " "])
    [p=[p=1 q=2] q=[~ [p=~~. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (ace [[1 1] " abc "])
    [p=[p=1 q=2] q=[~ [p=~~. q=[p=[p=1 q=2] q="abc "]]]]



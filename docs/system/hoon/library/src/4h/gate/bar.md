### `++bar`

Parse vertical bar

Parses ASCII character 124, the vertical bar.

Source
------

    ++  bar  (just '|')

Examples
--------

    ~zod/try=> (scan "|" bar)
    ~~~7c. 
    ~zod/try=> `cord`(scan "|" bar)
    '|'
    ~zod/try=> (bar [[1 1] "|"])
    [p=[p=1 q=2] q=[~ [p=~~~7c. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (bar [[1 1] "|="])
    [p=[p=1 q=2] q=[~ [p=~~~7c. q=[p=[p=1 q=2] q="="]]]]



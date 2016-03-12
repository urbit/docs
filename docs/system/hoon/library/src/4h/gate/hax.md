### `++hax`

Parse number sign

Parses ASCII character 35, the number sign.

Source
------

    ++  hax  (just '#')

Examples
--------

    ~zod/try=> (scan "#" hax)
    ~~~23.
    ~zod/try=> `cord`(scan "#" hax)
    '#'
    ~zod/try=> (hax [[1 1] "#"])
    [p=[p=1 q=2] q=[~ [p=~~~23. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (hax [[1 1] "#!"])
    [p=[p=1 q=2] q=[~ [p=~~~23. q=[p=[p=1 q=2] q="!"]]]]



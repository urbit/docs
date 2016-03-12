### `++hep`

Parse hyphen

Parses ASCII character 45, the hyphen.

Source
------

    ++  hep  (just '-')

Examples
--------

    ~zod/try=> (scan "-" hep)
    ~~-
    ~zod/try=> `cord`(scan "-" hep)
    '-'
    ~zod/try=> (hep [[1 1] "-"])
    [p=[p=1 q=2] q=[~ [p=~~- q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (hep [[1 1] ":-"])
    [p=[p=1 q=1] q=~]



### `++per`

Parse right parenthesis

Parses ASCII character 41, the right parenthesis.

Source
------

    ++  per  (just ')')

Examples
--------

    ~zod/try=> (scan ")" per)
    ~~~29.
    ~zod/try=> `cord`(scan ")" per)
    ')'
    ~zod/try=> (per [[1 1] ")"])
    [p=[p=1 q=2] q=[~ [p=~~~29. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (per [[1 1] " )"])
    [p=[p=1 q=1] q=~]



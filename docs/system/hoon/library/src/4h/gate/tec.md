### `++tec`

Parse backtick

Parses ASCII character 96, the backtick (also known as the "grave
accent").

Source
------

    ++  tec  (just '`')                                     ::  backTiCk

Examples
--------

    ~zod/try=> (scan "`" tec)
    ~~~6.
    ~zod/try=> `cord`(scan "`" tec)
    '`'
    ~zod/try=> (tec [[1 1] "`"])
    [p=[p=1 q=2] q=[~ [p=~~~6. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (tec [[1 1] " `"])
    [p=[p=1 q=1] q=~]



### `++sig`

Parse tilde

Parses ASCII character 126, the tilde.

Source
------

    ++  sig  (just '~')

Examples
--------

    ~zod/try=> (scan "~" sig)
    ~~~~
    ~zod/try=> `cord`(scan "~" sig)
    '~'
    ~zod/try=> (sig [[1 1] "~"])
    [p=[p=1 q=2] q=[~ [p=~~~~ q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (sig [[1 1] "?~"])
    [p=[p=1 q=1] q=~]



***

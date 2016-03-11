### `++zap`

Exclamation point

Parses ASCII character 33, the exclamation point zap.

Source
------

    ++  zap  (just '!')

Examples
--------

        ~zod/try=> (scan "!" zap)
        ~~~21.
        ~zod/try=> `cord`(scan "!" zap)
        '!'
        ~zod/try=> (zap [[1 1] "!"])
        [p=[p=1 q=2] q=[~ [p=~~~21. q=[p=[p=1 q=2] q=""]]]]
        ~zod/try=> (zap [[1 1] "?!"])
        [p=[p=1 q=1] q=~]



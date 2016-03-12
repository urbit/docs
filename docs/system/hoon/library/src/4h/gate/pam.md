### `++pam`

Parse ampersand

Parses ASCII character 38, the ampersand.

Source
------

    ++  pam  (just '&')

Examples
--------

    ~zod/try=> (scan "&" pam)
    ~~~26.
    ~zod/try=> `cord`(scan "&" pam)
    '&'
    ~zod/try=> (pam [[1 1] "&"])
    [p=[p=1 q=2] q=[~ [p=~~~26. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (pam [[1 1] "?&"])
    [p=[p=1 q=1] q=~]



***

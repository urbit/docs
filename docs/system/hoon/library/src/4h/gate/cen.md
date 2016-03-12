### `++cen`

Parses percent sign

Parses ASCII character 37, the percent sign.

Source
------

    ++  cen  (just '%')

Examples
--------

    ~zod/try=> (scan "%" cen)
    ~~~25.
    ~zod/try=> `cord`(scan "%" cen)
    '%'
    ~zod/try=> (cen [[1 1] "%"])
    [p=[p=1 q=2] q=[~ [p=~~~25. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (cen [[1 1] "%^"])
    [p=[p=1 q=2] q=[~ [p=~~~25. q=[p=[p=1 q=2] q="^"]]]] 



***

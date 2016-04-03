### `++tar`

Parse asterisk

Parses ASCII character 42, the asterisk.

Source
------

    ++  tar  (just '*')

Examples
--------

    ~zod/try=> (scan "*" tar)
    ~~~2a.
    ~zod/try=> `cord`(scan "*" tar)
    '*'
    ~zod/try=> (tar [[1 1] "*"])
    [p=[p=1 q=2] q=[~ [p=~~~2a. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (tar [[1 1] ".*"])
    [p=[p=1 q=1] q=~]



***

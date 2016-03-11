### `++pat`

Parse "at" sign

Parses ASCII character 64, the "at" sign.

Source
------

    ++  pat  (just '@')

Examples
--------

    ~zod/try=> (scan "@" pat)
    ~~~4.
    ~zod/try=> `cord`(scan "@" pat)
    '@'
    ~zod/try=> (pat [[1 1] "@"])
    [p=[p=1 q=2] q=[~ [p=~~~4. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (pat [[1 1] "?@"])
    [p=[p=1 q=1] q=~]



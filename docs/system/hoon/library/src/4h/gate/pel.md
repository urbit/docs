### `++pel`

Parse left parenthesis

Parses ASCII character 40, the left parenthesis.

Source
------

    ++  pel  (just '(')

Examples
--------

    ~zod/try=> (scan "(" pel)
    ~~~28.
    ~zod/try=> `cord`(scan "(" pel)
    '('
    ~zod/try=> (pel [[1 1] "("])
    [p=[p=1 q=2] q=[~ [p=~~~28. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (pel [[1 1] ";("])
    [p=[p=1 q=1] q=~]



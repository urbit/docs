### `++ker`

Parse right curley bracket

Parses ASCII character 125, the right curly bracket. Note that `{`
(`kel`) and `}` (`ker`) open and close a Hoon expression for Hoon string
interpolation. To parse either of them, they must be escaped.

Source
------

    ++  ker  (just '}')

Examples
--------

    ~zod/try=> (scan "}" ker)
    ~~~7d.
    ~zod/try=> `cord`(scan "}" ker)
    '}'
    ~zod/try=> (ker [[1 1] "}"])
    [p=[p=1 q=2] q=[~ [p=~~~7d. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (ker [[1 1] "\{}"])
    [p=[p=1 q=1] q=~]



***

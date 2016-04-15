### `++kel`

Parse left curley bracket

Parses ASCII character 123, the left curly bracket. Note that `{`
(`kel`) and `}` (`ker`) open and close a Hoon expression for Hoon string
interpolation. To parse either of them, they must be escaped.

Source
------

    ++  kel  (just '{')

Examples
--------

    ~zod/try=> (scan "\{" kel)
    ~~~7b.
    ~zod/try=> `cord`(scan "\{" kel)
    '{'
    ~zod/try=> (kel [[1 1] "\{"])
    [p=[p=1 q=2] q=[~ [p=~~~7b. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (kel [[1 1] " \{"])
    [p=[p=1 q=1] q=~]



***

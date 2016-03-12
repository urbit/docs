### `++ket`

Parse caret

Parses ASCII character 94, the caret.

Source
------

    ++  ket  (just '^')

Examples
--------

    ~zod/try=> (scan "^" ket)
    ~~~5e.
    ~zod/try=> `cord`(scan "^" ket)
    '^'
    ~zod/try=> (ket [[1 1] "^"])
    [p=[p=1 q=2] q=[~ [p=~~~5e. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (ket [[1 1] ".^"])
    [p=[p=1 q=1] q=~]


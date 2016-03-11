### `++doq`

Parse double quote

Parses ASCII character 34, the double quote.

Source
------

    ++  doq  (just '"')

Examples
--------

    ~zod/try=> (scan "\"" doq)
    ~~~22.
    ~zod/try=> `cord`(scan "\"" doq)
    '"'
    ~zod/try=> (doq [[1 1] "\""])
    [p=[p=1 q=2] q=[~ [p=~~~22. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (doq [[1 1] "not successfully parsed"])
    [p=[p=1 q=1] q=~]
    ~zod/try=> (scan "see?" doq)
    ! {1 1}
    ! 'syntax-error'
    ! exit 



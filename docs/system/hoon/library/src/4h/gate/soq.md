### `++soq`

Parse single quote

Parses ASCII character 39, soq. Note the extra '' is to escape the first
`soq` because soq delimits a [`++cord`]().

Source
------

    ++  soq  (just '\'')

Examples
--------

    ~zod/try=> (scan "'" soq)
    ~~~27.
    ~zod/try=> `cord`(scan "'" soq)
    '''
    ~zod/try=> (soq [[1 1] "'"])
    [p=[p=1 q=2] q=[~ [p=~~~27. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (soq [[1 1] ">'"])
    [p=[p=1 q=1] q=~]



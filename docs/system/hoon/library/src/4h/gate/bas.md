### `++bas`

Parse backslash

Parses ASCII character 92, the backslash. Note the extra `\` in the calling of
`bas` with [`++just`](/doc/hoon/library/2ec#++just) is to escape the escape
character, `\`.

Source
------

    ++  bas  (just '\\')

Examples
--------

    ~zod/try=> (scan "\\" bas)
    ~~~5c.
    ~zod/try=> `cord`(scan "\\" bas)
    '\'
    ~zod/try=> (bas [[1 1] "\"])
    ~ <syntax error at [1 18]>
    ~zod/try=> (bas [[1 1] "\\"])
    [p=[p=1 q=2] q=[~ [p=~~~5c. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (bas [[1 1] "\""])
    [p=[p=1 q=1] q=~]



***

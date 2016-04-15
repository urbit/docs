
### `++axis`

Nock axis

A Nock axis inside a [noun](). After the leading 1, in binary, a `1` signfies
right and `0` left.

Source
------

    ++  axis  ,@                                            ::  tree address

Examples
--------

    ~zod/try=> *axis
    0

    ~zod/try=> :: 0 is not actually a valid axis
    ~zod/try=> [[4 5] 6 7]
    [[4 5] 6 7]
    ~zod/try=> `axis`0b110
    6


***

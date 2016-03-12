### `++easy`

Always parse

Parser generator. Produces a parser that succeeds with given [noun]() `huf`
without consuming any text.

Accepts
-------

`huf` is a noun.

Produces
--------

A [`++rule`]().

Source
------

    ++  easy                                                ::  always parse
      ~/  %easy
      |*  huf=*
      ~/  %fun
      |=  tub=nail
      ^-  (like ,_huf)
      [p=p.tub q=[~ u=[p=huf q=tub]]]
    ::

Examples
--------

    ~zod/try=> ((easy %foo) [[1 1] "abc"])
    [p=[p=1 q=1] q=[~ [p=%foo q=[p=[p=1 q=1] q="abc"]]]]
    ~zod/try=> ((easy %foo) [[1 1] "bc"])
    [p=[p=1 q=1] q=[~ [p=%foo q=[p=[p=1 q=1] q="bc"]]]]
    ~zod/try=> ((easy 'a') [[1 1] "bc"])
    [p=[p=1 q=1] q=[~ [p='a' q=[p=[p=1 q=1] q="bc"]]]]



***

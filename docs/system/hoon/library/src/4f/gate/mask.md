### `++mask`

Match char

Parser generator. Matches the next character if it is in a list of
characters.

Accepts
-------

`bud` is a list of [`++char`]()

Produces
--------

A [`++rule`]().

Source
------

    ++  mask                                                ::  match char in set
      ~/  %mask
      |=  bud=(list char)
      ~/  %fun
      |=  tub=nail
      ^-  (like char)
      ?~  q.tub
        (fail tub)
      ?.  (lien bud |=(a=char =(i.q.tub a)))
        (fail tub)
      (next tub)
    ::

Examples
--------

    ~zod/try=> (scan "a" (mask "cba"))
    ~~a
    ~zod/try=> ((mask "abc") [[1 1] "abc"])
    [p=[p=1 q=2] q=[~ [p=~~a q=[p=[p=1 q=2] q="bc"]]]]
    ~zod/try=> ((mask "abc") [[1 1] "bbc"])
    [p=[p=1 q=2] q=[~ [p=~~b q=[p=[p=1 q=2] q="bc"]]]]
    ~zod/try=> ((mask "abc") [[1 1] "dbc"])
    [p=[p=1 q=1] q=~]



***

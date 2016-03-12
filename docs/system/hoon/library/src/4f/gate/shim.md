### `++shim`

Char in range

Match characters ([`++char`]()) within a range.

Accepts
-------

`les` is an atom.

`mos` is an atom.

Produces
--------

A [`++rule`]().

Source
------

    ++  shim                                                ::  match char in range
      ~/  %shim
      |=  [les=@ mos=@]
      ~/  %fun
      |=  tub=nail
      ^-  (like char)
      ?~  q.tub
        (fail tub)
      ?.  ?&((gte i.q.tub les) (lte i.q.tub mos))
        (fail tub)
      (next tub)
    ::

Examples
--------

    ~zod/try=> ((shim 'a' 'z') [[1 1] "abc"])
    [p=[p=1 q=2] q=[~ [p=~~a q=[p=[p=1 q=2] q="bc"]]]]
    ~zod/try=> ((shim 'a' 'Z') [[1 1] "abc"])
    [p=[p=1 q=1] q=~]
    ~zod/try=> ((shim 'a' 'Z') [[1 1] "Abc"])
    [p=[p=1 q=2] q=[~ [p=~~~41. q=[p=[p=1 q=2] q="bc"]]]]



***

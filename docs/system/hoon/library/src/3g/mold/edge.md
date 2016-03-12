### `++edge`

Parsing location metadata

Optional result `p` and parsing continuation `q`.

Source
------

        ++  edge  ,[p=hair q=(unit ,[p=* q=nail])]              ::  parsing output

Examples
--------

See also: Section 2eD, [`++rule`]()

    ~zod/try=> *edge
    [p=[p=0 q=0] q=~]
    ~zod/try=> (tall:vast [1 1] "a b")
    [p=[p=1 q=2] q=[~ [p=[%cnzz p=~[%a]] q=[p=[p=1 q=2] q=" b"]]]]



***

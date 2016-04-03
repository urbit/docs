
### `++base`

Base type

A base type that [noun]()s are built from. A `++base` is either a noun, cell, boolean or
null labelled with an [odor]().

Source
------

    ++  base  ?([%atom p=odor] %noun %cell %bean %null)     ::  axils, @ * ^ ? ~

Examples
--------

    ~zod/try=> *base
    %null

    ~zod/try=> (ream '=|(^ !!)')
    [%tsbr p=[%axil p=%cell] q=[%zpzp ~]]
    ~zod/try=> :: p.p is a ++base
    ~zod/try=> (ream '=|(@t !!)')
    [%tsbr p=[%axil p=[%atom p=~.t]] q=[%zpzp ~]]
    ~zod/try=> (ream '=|(? !!)')
    [%tsbr p=[%axil p=%bean] q=[%zpzp ~]]


***

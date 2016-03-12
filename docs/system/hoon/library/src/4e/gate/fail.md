### `++fail`

Never parse

Produces an [`++edge`]() at the same text position ([`++hair`]()) with a failing
result (`q=~`).

Accepts
-------

`tub` is a [`++nail`]().

Produces
--------

An `++edge`.

Source
------

    ++  fail  |=(tub=nail [p=p.tub q=~])                    ::  never parse

Examples
--------

    ~zod/try=> (fail [[1 1] "abc"])
    [p=[p=1 q=1] q=~]
    ~zod/try=> (fail [[p=1.337 q=70] "Parse me, please?"])
    [p=[p=1.337 q=70] q=~]



***

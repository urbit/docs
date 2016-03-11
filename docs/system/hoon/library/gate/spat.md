### `++spat`

Render path as cord

Renders a path `pax` as cord.

Accepts
-------

Produces
--------

`pax` is a [`path`]().

Source
------

    ++  spat  |=(pax=path (crip (spud pax)))               ::  path to cord

Examples
--------

    ~zod/try=> (spat %)
    '~zod/try/~2014.10.28..18.40.20..4287'
    ~zod/try=> (spat %/bin)
    '~zod/try/~2014.10.28..18.41.12..3bcd/bin'
    ~zod/try=> (spat /as/les/top)
    '/as/les/top'



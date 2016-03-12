### `++spud`

Render path as tape

Renders a path `pax` as [tape]().

Accepts
-------

Produces
--------

`pax` is a [`path`]().

Source
------

    ++  spud  |=(pax=path ~(ram re (smyt pax)))             ::  path to tape

Examples
--------

    ~zod/try=> (spud %)
    "~zod/try/~2014.10.28..18.40.46..e951"
    ~zod/try=> (spud %/bin)
    "~zod/try/~2014.10.28..18.41.05..16f2/bin"
    ~zod/try=> (spud /as/les/top)
    "/as/les/top"



***

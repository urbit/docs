---
navhome: /docs/
---


### `++file`

Simple file load

Reads the value of a file located at `pax` and renders it as a
[`++unit`]().

Accepts
-------

`pax` is a [`++path`]().

Produces
--------

The `++unit` of a [`++noun`]().

Source
------

    ++  file                                                ::  simple file load
          |=  pax=path
          ^-  (unit)
          =+  dir=((hard arch) .^(%cy pax))
          ?~(q.dir ~ [~ .^(%cx pax)])
        ::

Examples
--------

    ~zod/try=> %/zak
    ~zod/try=/zak> :ls %
    ~zod/try=/zak> + %/mop 20
    + /~zod/try/3/zak/mop
    ~zod/try=/zak> :ls %
    mop
    ~zod/try=/zak> (file %/mop)
    [~ 20]
    ~zod/try=/zak> (file %/lak)
    ~
    ~zod/try=/zak> (file /==2%/mop)
    ~



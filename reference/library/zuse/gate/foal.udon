---
navhome: /docs/
---



### `++foal`

Write high-level change

Produces a [`++toro`](), a change intended for whatever file is located
at `pax`. Handled by `%clay`.

Accepts
-------

`pax` is a [`++path`]().

`val` is a value as a [noun]().

Produces
--------

A [`++toro`]().

Source
------

    ++  foal                                                ::  high-level write
          |=  [pax=path val=*]
          ^-  toro
          ?>  ?=([* * * *] pax)
          [i.t.pax [%& [*cart [[t.t.t.pax (feel pax val)] ~]]]]
        ::

Examples
--------

    ~zod/try=> + %/mek 'a'
    + /~zod/try/4/mek
    ~zod/try=> (foal %/mek 'b')
    [ p=~.try
        q
      [%.y q=[p=[p=0v0 q=0v0] q=~[[p=/mek q=[%mut p=[p=%a q=[%a p=97 q=98]]]]]]]
    ]
    ~zod/try=> (feel %/mek 'b')
    [%mut p=[p=%a q=[%a p=97 q=98]]]


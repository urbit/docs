---
navhome: /docs/
---



### `++tome`

Parse path to beam

Parses a [`++path`]() `pax` to a [`++beam](), a well-typed location.

Accepts
-------

`pax` is a [`++path`]().

Produces
--------

A `(unit beam)`.

Source
------

    ++  tome                                                ::  parse path to beam
          |=  pax=path
          ^-  (unit beam)
          ?.  ?=([* * * *] pax)  ~
          %+  biff  (slaw %p i.pax)
          |=  who=ship
          %+  biff  (slaw %tas i.t.pax)
          |=  dex=desk
          %+  biff  (slay i.t.t.pax)
          |=  cis=coin
          ?.  ?=([%$ case] cis)  ~
          `(unit beam)`[~ [who dex `case`p.cis] (flop t.t.t.pax)]
        ::

Examples
--------

    ~zod/try=/zop> (tome /~fyr/try/2/for/me)
    [~ [[p=~fyr q=%try r=[%ud p=2]] s=/me/for]]
    ~zod/try=/zop> (tome /~zod/main/1)
    [~ [[p=~zod q=%main r=[%ud p=1]] s=/]]
    ~zod/try=/zop> (tome /0/main/1)
    ~
    ~zod/try=/zop> (tome /~zod/main/0x12)
    ~


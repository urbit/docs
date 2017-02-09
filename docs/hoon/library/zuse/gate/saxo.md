---
navhome: /docs/
---


### `++saxo`

List ancestors

Lists the ancestors of `who`.

Accepts
-------

`who` is a [`++ship`]().

Produces
--------

A [`++list`]() of `++ship`.

Source
------

    ++  saxo                                                ::  autocanon
      |=  who=ship
      ^-  (list ship)
      ?:  (lth who 256)  [who ~]
      [who $(who (sein who))]
    ::
    
Examples
--------

    ~zod/main=> (saxo ~pittyp-pittyp)
    ~[~pittyp-pittyp ~dalnel ~del]
    ~zod/main=> (saxo ~tasfyn-partyv)
    ~[~tasfyn-partyv ~doznec ~zod]
    ~zod/main=> (saxo ~ractul-fodsug-sibryg-modsyl--difrun-mirfun-filrec-patmet)
    ~[~ractul-fodsug-sibryg-modsyl--difrun-mirfun-filrec-patmet ~zod]



---
navhome: /docs/
---


### `++sein`

Direct parent

Computes the direct parent of `who`.

Accepts
-------

`who` is a [`++ship`]().

Produces
--------

A `++ship`.

Source
------

    ++  sein                                                ::  autoboss
      |=  who=ship  ^-  ship
      =+  mir=(clan who)
      ?-  mir
        %czar  who
        %king  (end 3 1 who)
        %duke  (end 4 1 who)
        %earl  (end 5 1 who)
        %pawn  `@p`0
      ==

Examples
--------

    ~zod/main=> (sein ~tasfyn-partyv)
    ~doznec
    ~zod/main=> (sein ~doznec)
    ~zod
    ~zod/main=> (sein ~zod)
    ~zod
    ~zod/main=> (sein ~pittyp-pittyp)
    ~dalnel
    ~zod/main=> (sein ~dalnel)
    ~del
    ~zod/main=> (sein ~ractul-fodsug-sibryg-modsyl--difrun-mirfun-filrec-patmet)
    ~zod

    ~zod/main=> (saxo ~rabdec-monfer)
    ~[~rabdec-monfer ~dalnel ~del]
    ~zod/main=> `@rd`~rabdec-monfer
    0x5fd25
    [%rlyd 0x5.fd25]
    0b1.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000
    ~zod/main=> `@p`0x5.fd25
    ~rabdec-monfer

    For `@rd` and `@p` see the [odors](../reference/odors) reference

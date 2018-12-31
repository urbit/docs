---
navhome: /docs/
---


### `++clan`

Ship class

Accepts
-------

`who` is a [`++ship`]()

Produces
--------

A [`%cube`]().

Source
------

    ++  clan                                                ::  ship to rank
      |=  who=ship  ^-  rank
      =+  wid=(met 3 who)
      ?:  (lte wid 1)   %czar
      ?:  =(2 wid)      %king
      ?:  (lte wid 4)   %duke
      ?:  (lte wid 8)   %earl
      ?>  (lte wid 16)  %pawn
    ::

Examples
--------

    ~zod/main=> (clan ~zod)
    %czar
    ~zod/main=> (clan ~tyr)
    %czar
    ~zod/main=> (clan ~doznec)
    %king
    ~zod/main=> (clan ~tasfyn-partyv)
    %duke



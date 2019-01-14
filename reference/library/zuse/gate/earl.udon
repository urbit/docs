---
navhome: /docs/
---


### `++earl`

Localize purl

Prepends a ship name to the spur of a [`++purl`]().

Accepts
-------

`who` is a [`@p`](), a ship name.

`pul` is a `++purl`.

Produces
--------

A `++purl`.

Source
------

    ++  earl                                                ::  localize purl
          |=  [who=@p pul=purl]
          ^-  purl
          pul(q.q [(rsh 3 1 (scot %p who)) q.q.pul])
        ::

Examples
--------

    ~zod/main=> (need (epur 'http://123.1.1.1/me.ham'))
    [p=[p=%.n q=~ r=[%.n p=.123.1.1.1]] q=[p=[~ ~.ham] q=<|me|>] r=~]
    ~zod/main=> (earl ~zod (need (epur 'http://123.1.1.1/me.ham')))
    [p=[p=%.n q=~ r=[%.n p=.123.1.1.1]] q=[p=[~ ~.ham] q=<|zod me|>] r=~]
    ~zod/main=> (earl ~pittyp (need (epur 'http://123.1.1.1/me.ham')))
    [p=[p=%.n q=~ r=[%.n p=.123.1.1.1]] q=[p=[~ ~.ham] q=<|pittyp me|>] r=~]
    ~zod/main=> (earn (earl ~pittyp (need (epur 'http://123.1.1.1/me.ham'))))
    "http://123.1.1.1/pittyp/me"



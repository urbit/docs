---
navhome: /docs/
---


### `++urld`

Decode URL

The inverse of [`++urle`](). Parses a URL escaped [`++tape`]() to the
[`++unit`]() of an unescaped `++tape`.

Accepts
-------

`tep` is a `++tape`.

Produces
--------

The [`++unit`]() of a `++tape`.

Source
------

    ++  urld                                                ::  URL decode
          |=  tep=tape
          ^-  (unit tape)
          ?~  tep  [~ ~]
          ?:  =('%' i.tep)
            ?.  ?=([@ @ *] t.tep)  ~
            =+  nag=(mix i.t.tep (lsh 3 1 i.t.t.tep))
            =+  val=(rush nag hex:ag)
            ?~  val  ~
            =+  nex=$(tep t.t.t.tep)
            ?~(nex ~ [~ [`@`u.val u.nex]])
          =+  nex=$(tep t.tep)
          ?~(nex ~ [~ i.tep u.nex])
        ::

Examples
--------

    ~zod/main=> (urld "hello")
    [~ "hello"]
    ~zod/main=> (urld "hello%20dear")
    [~ "hello dear"]
    ~zod/main=> (urld "hello-my%3F%3Dme%20%20%21")
    [~ "hello-my?=me  !"]
    ~zod/main=> (urld "hello-my%3F%3Dme%20%2%21")
    ~



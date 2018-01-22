---
navhome: /docs/
---


### `++tame`

Parse kite path

Parses a clay [.\^]()
[`++path` ]()to request details. Produces the [`++unit`]() of a [`++kite`]().

Accepts
-------

`hap` is a [`++path`]().

Produces
--------

A `(unit kite)`.

Source
------

    ++  tame                                                ::  parse kite path
          |=  hap=path
          ^-  (unit kite)
          ?.  ?=([@ @ @ @ *] hap)  ~
          =+  :*  hyr=(slay i.hap)
                  fal=(slay i.t.hap)
                  dyc=(slay i.t.t.hap)
                  ved=(slay i.t.t.t.hap)
                  ::  ved=(slay i.t.hap)
                  ::  fal=(slay i.t.t.hap)
                  ::  dyc=(slay i.t.t.t.hap))
                  tyl=t.t.t.t.hap
              ==
          ?.  ?=([~ %$ %tas @] hyr)  ~
          ?.  ?=([~ %$ %p @] fal)  ~
          ?.  ?=([~ %$ %tas @] dyc)  ~
          ?.  ?=([~ %$ case] ved)  ~
          =+  his=`@p`q.p.u.fal
          =+  [dis=(end 3 1 q.p.u.hyr) rem=(rsh 3 1 q.p.u.hyr)]
          ?.  ?&(?=(%c dis) ?=(?(%v %w %x %y %z) rem))  ~
          [~ rem p.u.ved q.p.u.fal q.p.u.dyc tyl]
        ::

Examples
--------

    ~zod/try=/zop> (tame /cx/~zod/main/1/sur/down/gate/hook)
    [~ [p=%x q=[%ud p=1] r=~zod s=%main t=/sur/down/gate/hook]]
    ~zod/try=/zop> (tame /cx/0/main/1/sur/down/gate/hook)
    ~
    ~zod/try=/zop> (tame /~zod/main/0x12/sur/down/gate/hook)
    ~



---
navhome: /docs/
---


### `++deal`

Add leap seconds

Produces a [`++date`]() with the 25 leap seconds added.

Accepts
-------

`yer` is an absolute date, [`@da`]().

Produces
--------

A `++date`.

Source
------

    ++  deal                                                ::  to leap sec time
      |=  yer=@da
      =+  n=0
      =+  yud=(yore yer)
      |-  ^-  date
      ?:  (gte yer (add (snag n lef:yu) ~s1))
        (yore (year yud(s.t (add n s.t.yud))))
      ?:  &((gte yer (snag n lef:yu)) (lth yer (add (snag n lef:yu) ~s1)))
        yud(s.t (add +(n) s.t.yud))
      ?:  =(+(n) (lent lef:yu))
        (yore (year yud(s.t (add +(n) s.t.yud))))
      $(n +(n))
    ::

Examples
--------

    ~zod/try=> (yore (bex 127))
    [[a=%.y y=226] m=12 t=[d=5 h=15 m=30 s=8 f=~]]
    ~zod/try=> (deal `@da`(bex 127))
    [[a=%.y y=226] m=12 t=[d=5 h=15 m=30 s=33 f=~]]
    ~zod/try=> (yore (bex 126))
    [[a=%.n y=146.138.512.088] m=6 t=[d=19 h=7 m=45 s=4 f=~]]



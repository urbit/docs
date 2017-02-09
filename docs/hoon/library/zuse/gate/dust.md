---
navhome: /docs/
---


### `++dust`

Print UTC format

Produces a [`++tape`]() of the date in UTC format.

Accepts
-------

`yed` is a [`++date`]().

Produces
--------

A `++tape`.

Source
------

    ++  dust                                                ::  print UTC format
      |=  yed=date
      ^-  tape
      =+  wey=(daws yed)
      ;:  weld
          `tape`(snag wey (turn wik:yu |=(a=tape (scag 3 a))))
          ", "  ~(rud at d.t.yed)  " "
          `tape`(snag (dec m.yed) (turn mon:yu |=(a=tape (scag 3 a))))
          " "  (scag 1 ~(rud at y.yed))  (slag 2 ~(rud at y.yed))  " "
          ~(rud at h.t.yed)  ":"  ~(rud at m.t.yed)  ":"  ~(rud at s.t.yed)
          " "  "+0000"
      ==
    ::

Examples
--------

    ~zod/try=> (dust (yore ->-))
    "Tue, 21 Oct 2014 21:35:12 +0000"
    ~zod/try=> (dust [[a=%.y y=2.002] m=10 t=[d=11 h=12 m=20 s=55 f=~]])
    "Fri, 11 Oct 2002 12:20:55 +0000"



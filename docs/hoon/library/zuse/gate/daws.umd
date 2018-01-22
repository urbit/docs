---
navhome: /docs/
---


### `++daws`

Weekday of date

Produces the day of the week of a given date `yed` as an atom. Weeks are
zero-indexed beginning on Sunday.

Accepts
-------

`yed` is a [`++date`]().

Produces
--------

An atom.

Source
------

    ++  daws                                                ::  weekday of date
      |=  yed=date
      %-  mod  :_  7
      (add (dawn y.yed) (sub (yawn [y.yed m.yed d.t.yed]) (yawn y.yed 1 1)))
    ::

Examples
--------

    ~zod/try=> (daws [[a=%.y y=2.014] m=6 t=[d=6 h=21 m=9 s=15 f=~[0xa16]]])
    5
    ~zod/try=> (daws (yore -<-))
    2

(second example always returns the current date).



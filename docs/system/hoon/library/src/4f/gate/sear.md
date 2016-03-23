### `++sear`

Conditional `++cook`

Conditional `++cook`. Slams the result through a gate that produces
a unit; if that unit is empty, fail.

Accepts
-------

`tub` is a `++nail`.
Produces
--------

A `++rule`.

Source
------

    ++  sear                                                ::  conditional cook
      |*  {pyq/$-(* (unit)) sef/rule}
      |=  tub/nail
      =+  vex=(sef tub)
      ?~  q.vex
        vex
      =+  gey=(pyq p.u.q.vex)
      ?~  gey
        [p=p.vex q=~]
      [p=p.vex q=[~ u=[p=u.gey q=q.u.q.vex]]]
    ::


Examples
--------

    ~zod/try=> ((sear |=(a/* ?@(a (some a) ~)) (just `a`)) [[1 1] "abc"])
    [p=[p=1 q=2] q=[~ u=[p=97 q=[p=[p=1 q=2] q="bc"]]]]
    ~zod/try=> ((sear |=(* ~) (just 'a')) [[1 1] "abc"])
    [p=[p=1 q=2] q=~]



***

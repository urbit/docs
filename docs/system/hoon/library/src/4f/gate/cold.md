### `++cold`

Replace with constant

Parser modifier. Accepts a `++rule` `sef` and produces a parser that
produces a constant `cus`, assuming `sef` is successful.

Accepts
-------

`cus` is a constant noun.

`sef` is a `++rule`.

Produces
--------

An `++edge`.

Source
------

    ++  cold                                                ::  replace w+ constant
      ~/  %cold
      |*  {cus/* sef/rule}
      ~/  %fun
      |=  tub/nail
      =+  vex=(sef tub)
      ?~  q.vex
        vex
      [p=p.vex q=[~ u=[p=cus q=q.u.q.vex]]]

Examples
--------

        ~zod/try=> ((cold %foo (just 'a')) [[1 1] "abc"])
        [p=[p=1 q=2] q=[~ u=[p=%foo q=[p=[p=1 q=2] q="bc"]]]]
        ~zod/try=> ((cold %foo (just 'a')) [[1 1] "bc"])
        [p=[p=1 q=1] q=~]



***

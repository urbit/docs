### `++here`

Place-based apply

Parser modifier. Similar to [`++cook`]() in that it produces a parser that takes a
(successful) result of `sef` and slams it through `hez`. `hez` accepts a
[`++pint`]() `a` and a [noun]() `b`, which is what the parser parsed.

Accepts
-------

`hez` is a [gate]().

`sef` is a [`++rule`]()

Produces
--------

A `++rule`.

Source
------

    ++  here                                                ::  place-based apply
      ~/  %here
      |*  [hez=_|=([a=pint b=*] [a b]) sef=_rule]
      ~/  %fun
      |=  tub=nail
      =+  vex=(sef tub)
      ?~  q.vex
        vex
      [p=p.vex q=[~ u=[p=(hez [p.tub p.q.u.q.vex] p.u.q.vex) q=q.u.q.vex]]]
    ::

Examples
--------

    ~zod/try=> (scan "abc" (star alf))
    "abc"
    ~zod/try=> (scan "abc" (here |*(^ +<) (star alf)))
    [[[p=1 q=1] p=1 q=4] "abc"]
    ~zod/try=> (scan "abc" (star (here |*(^ +<) alf)))
    ~[[[[p=1 q=1] p=1 q=2] ~~a] [[[p=1 q=2] p=1 q=3] ~~b] [[[p=1 q=3] p=1 q=4] ~~c]]



***

### `++cook`

Apply gate

Parser modifier. Produces a parser that takes a (successful) result of a
[`++rule`]() `sef` and slams it through `poq`.

Accepts
-------

`poq` is a [gate]().

`sef` is a [`++rule`]().

Produces
--------

An [`++rule`]().

Source
------

    ++  cook                                                ::  apply gate
      ~/  %cook
      |*  [poq=_,* sef=_rule]
      ~/  %fun
      |=  tub=nail
      =+  vex=(sef tub)
      ?~  q.vex
        vex
      [p=p.vex q=[~ u=[p=(poq p.u.q.vex) q=q.u.q.vex]]]
    ::

Examples
--------

        ~zod/try=> ((cook ,@ud (just 'a')) [[1 1] "abc"])
        [p=[p=1 q=2] q=[~ u=[p=97 q=[p=[p=1 q=2] q="bc"]]]]
        ~zod/try=> ((cook ,@tas (just 'a')) [[1 1] "abc"])
        [p=[p=1 q=2] q=[~ u=[p=%a q=[p=[p=1 q=2] q="bc"]]]]
        ~zod/try=> ((cook |=(a=@ +(a)) (just 'a')) [[1 1] "abc"])
        [p=[p=1 q=2] q=[~ u=[p=98 q=[p=[p=1 q=2] q="bc"]]]]
        ~zod/try=> ((cook |=(a=@ `@t`+(a)) (just 'a')) [[1 1] "abc"])
        [p=[p=1 q=2] q=[~ u=[p='b' q=[p=[p=1 q=2] q="bc"]]]]



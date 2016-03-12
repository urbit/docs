### `++full`

Parse to end

Parser modifier. Accepts a [`++rule`]() `sef`, and produces a parser that succeeds only
when the of `tub` is fully consumed using `sef`.

Accepts
-------

`sef` is a [`++rule`]().

Produces
--------

A `++rule`.

Source
------

    ++  full                                                :: parse to end 
      |*  sef=_rule
      |=  tub=nail
      =+  vex=(sef tub)
      ?~(q.vex vex ?:(=(~ q.q.u.q.vex) vex [p=p.vex q=~]))
    ::

Examples
--------

    ~zod/try=> ((full (just 'a')) [[1 1] "ab"])
    [p=[p=1 q=2] q=~]
    ~zod/try=> ((full (jest 'ab')) [[1 1] "ab"])
    [p=[p=1 q=3] q=[~ u=[p='ab' q=[p=[p=1 q=3] q=""]]]]
    ~zod/try=> ((full ;~(plug (just 'a') (just 'b'))) [[1 1] "ab"])
    [p=[p=1 q=3] q=[~ u=[p=[~~a ~~b] q=[p=[p=1 q=3] q=""]]]]



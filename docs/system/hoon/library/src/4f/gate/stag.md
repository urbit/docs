### `++stag`

Add label

Add a label to an edge parsed by a rule.

Accepts
-------

`gob` is a noun.

`sef` is a rule.

Produces
--------

A [`++rule`]().

Source
------

    ++  stag                                                ::  add a label
      ~/  %stag
      |*  [gob=* sef=_rule]
      ~/  %fun
      |=  tub=nail
      =+  vex=(sef tub)
      ?~  q.vex
        vex
      [p=p.vex q=[~ u=[p=[gob p.u.q.vex] q=q.u.q.vex]]]
    ::

Examples
--------

    ~zod/try=> ((stag %foo (just 'a')) [[1 1] "abc"])
    [p=[p=1 q=2] q=[~ u=[p=[%foo ~~a] q=[p=[p=1 q=2] q="bc"]]]]
    ~zod/try=> ((stag "xyz" (jest 'abc')) [[1 1] "abc"])
    [p=[p=1 q=4] q=[~ u=[p=["xyz" 'abc'] q=[p=[p=1 q=4] q=""]]]]
    ~zod/try=> ((stag 10.000 (shim 0 100)) [[1 1] "abc"])
    [p=[p=1 q=2] q=[~ u=[p=[10.000 ~~a] q=[p=[p=1 q=2] q="bc"]]]]



***

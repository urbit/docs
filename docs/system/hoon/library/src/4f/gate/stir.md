### `++stir`

Parse repeatedly

Parse with [`++rule`]() as many times as possible, and fold over results with a
binary gate.

Accepts
-------

`rud` is a noun.

`raq` is a gate that takes two nouns and produces a cell.

`fel` is a rule.

Produces
--------

A rule.

Source
------

++  stir                                                ::  parse repeatedly 
      ~/  %stir
      |*  [rud=* raq=_|*([a=* b=*] [a b]) fel=_rule]
      ~/  %fun
      |=  tub=nail
      ^-  (like ,_rud)
      =+  vex=(fel tub)
      ?~  q.vex
        [p.vex [~ rud tub]]
      =+  wag=$(tub q.u.q.vex)
      ?>  ?=(^ q.wag)
      [(last p.vex p.wag) [~ (raq p.u.q.vex p.u.q.wag) q.u.q.wag]]
    ::

Examples
--------

    ~zod/try=> (scan "abc" (stir *@ add prn))
    294
    ~zod/try=> (roll "abc" add)
    b=294



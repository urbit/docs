### `++stir`

Parse repeatedly

Parse with `++rule` as many times as possible, and fold over results with a
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

    ++  stun                                                ::  parse several times
      |*  {lig/{@ @} fel/rule}
      |=  tub/nail
      ^-  (like (list _(wonk (fel))))
      ?:  =(0 +.lig)
        [p.tub [~ ~ tub]]
      =+  vex=(fel tub)
      ?~  q.vex
        ?:  =(0 -.lig)
          [p.vex [~ ~ tub]]
        vex
      =+  ^=  wag  %=  $
                     -.lig  ?:(=(0 -.lig) 0 (dec -.lig))
                     +.lig  ?:(=(0 +.lig) 0 (dec +.lig))
                     tub  q.u.q.vex
                   ==
      ?~  q.wag
        wag
      [p.wag [~ [p.u.q.vex p.u.q.wag] q.u.q.wag]]


Examples
--------

    ~zod/try=> (scan "abc" (stir *@ add prn))
    294
    ~zod/try=> (roll "abc" add)
    b=294



***

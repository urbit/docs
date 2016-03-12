### `++ven`

`+>-` axis syntax

Axis syntax parser

Source
------

    ++  ven  ;~  (comp |=([a=@ b=@] (peg a b)))             ::  +>- axis syntax
               bet
               =+  hom=`?`|
               |=  tub=nail
               ^-  (like axis)
               =+  vex=?:(hom (bet tub) (gul tub))
               ?~  q.vex
                 [p.tub [~ 1 tub]]
               =+  wag=$(p.tub p.vex, hom !hom, tub q.u.q.vex)
               ?>  ?=(^ q.wag)
               [p.wag [~ (peg p.u.q.vex p.u.q.wag) q.u.q.wag]]
             ==

Examples
--------

    ~zod/arvo=/hoon/hoon> (scan "->+" ven)
    11
    ~zod/arvo=/hoon/hoon> `@ub`(scan "->+" ven)
    0b1011
    ~zod/arvo=/hoon/hoon> (peg (scan "->" ven) (scan "+" ven))
    11
    ~zod/arvo=/hoon/hoon> ->+:[[1 2 [3 4]] 5]
    [3 4]



### `++plug`

Parse to tuple

Parsing composer: connects an [`++edge`]() `vex` with a following [`++rule`]() `sab`, producing
a cell of both the results. See also: the monad applicator [;\~]() for a
more detailed explanation.

Accepts
-------

`sab` is a `++rule`.

`vex` is an `++edge`.

Produces
--------



Source
------

    ++  plug                                                ::  first then second
      ~/  %plug
      |*  [vex=edge sab=_rule]
      ?~  q.vex
        vex
      =+  yit=(sab q.u.q.vex)
      =+  yur=(last p.vex p.yit)
      ?~  q.yit
        [p=yur q=q.yit]
      [p=yur q=[~ u=[p=[p.u.q.vex p.u.q.yit] q=q.u.q.yit]]]
    ::

Examples
--------

    ~zod/try=> (scan "1..20" ;~(plug dem dot dot dem))
    [q=1 ~~~. ~~~. q=20]
    ~zod/try=> (scan "moke/~2014.1.1" ;~(plug sym fas nuck:so))
    [1.701.539.693 ~~~2f. [% p=[p=~.da q=170.141.184.500.766.106.671.844.917.172.921.958.400]]]
    ~zod/try=> ;;(,[@tas @t ~ %da @da] (scan "moke/~2014.1.1" ;~(plug sym fas nuck:so)))
    [%moke '/' ~ %da ~2014.1.1]



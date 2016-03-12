### `++comp`

Arbitrary compose

Parsing composer: connects the [`++edge`]() `vex` with a following [`++rule`]() `sab`,
combining the contents of `vex` with the result of `sab` using a binary
[gate]() `raq`. Used to fold over the results of several `++rules`.

Accepts
-------

`raq` is a gate that accepts a cell of two [nouns](), `a` and `b`, and
produces a cell of two nouns.

`sab` is a rule.

`vex` is an edge.

Produces
--------

A [`++rule`]().

Source
------

    ++  comp
      ~/  %comp
      |*  raq=_|*([a=* b=*] [a b])                          ::  arbitrary compose
      ~/  %fun
      |*  [vex=edge sab=_rule]
      ?~  q.vex
        vex
      =+  yit=(sab q.u.q.vex)
      =+  yur=(last p.vex p.yit)
      ?~  q.yit
        [p=yur q=q.yit]
      [p=yur q=[~ u=[p=(raq p.u.q.vex p.u.q.yit) q=q.u.q.yit]]]
    ::

Examples
--------

    ~zod/try=> (scan "123" ;~((comp |=([a=@u b=@u] (add a b))) dit dit dit))
    6
    ~zod/try=> (scan "12" ;~((comp |=([a=@u b=@u] (add a b))) dit dit dit))
    ! {1 3}
    ! exit

***

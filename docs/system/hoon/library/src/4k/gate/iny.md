### `++iny`

Indentation block

Apply [`++rule`]() to indented block starting at current column number, omitting
the leading whitespace.

Accepts
-------

`sef` is a [`++rule`]()

Produces
--------

A `++rule`.

Source
------

    ++  iny  |*  sef=_rule                                 :: indentation block
      |=  nail  ^+  (sef)
      =+  [har tap]=[p q]:+<
      =+  lev=(fil 3 (dec q.har) ' ')
      =+  eol=(just `@t`10)
      =+  =-  roq=((star ;~(pose prn ;~(sfix eol (jest lev)) -)) har tap)
          ;~(simu ;~(plug eol eol) eol)
      ?~  q.roq  roq
      =+  vex=(sef har(q 1) p.u.q.roq)
      =+  fur=p.vex(q (add (dec q.har) q.p.vex))
      ?~  q.vex  vex(p fur)
      =-  vex(p fur, u.q -)
      :+  &3.vex
        &4.vex(q.p (add (dec q.har) q.p.&4.vex))
      =+  res=|4.vex
      |-  ?~  res  |4.roq
      ?.  =(10 -.res)  [-.res $(res +.res)]
      (welp [`@t`10 (trip lev)] $(res +.res))
    ::

Examples
--------

    ~zod/try=> (scan "abc" (iny (star ;~(pose prn (just `@`10)))))
    "abc"
    ~zod/try=> (scan "abc" (star ;~(pose prn (just `@`10))))
    "abc"
    ~zod/try=> (scan "  abc\0ade" ;~(pfix ace ace (star ;~(pose prn (just `@`10)))))
    "abc
        de"
    ~zod/try=> (scan "  abc\0ade" ;~(pfix ace ace (iny (star ;~(pose prn (just `@`10))))))
    ! {1 6}
    ! exit
    ~zod/try=> (scan "  abc\0a  de" ;~(pfix ace ace (iny (star ;~(pose prn (just `@`10))))))
    "abc
        de"



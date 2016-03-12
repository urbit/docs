### `++less`

Parse unless

Parsing composer: if an [`++edge`]() `vex` reflects a success, fail. Otherwise,
connect `vex` with the following [`++rule`]().

Accepts
-------

`sab` is a `++rule`.

`vex` is an `++edge`.

Produces
--------



Source
------

    ++  less                                                ::  no first and second
      |*  [vex=edge sab=_rule]
      ?~  q.vex
        =+  roq=(sab)
        [p=(last p.vex p.roq) q=q.roq]
      vex(q ~)
    ::

Examples
--------

    ~zod/try=> (scan "sas-/lo" (star ;~(less lus bar prn)))
    "sas-/lo"
    ~zod/try=> (scan "sas-/l+o" (star ;~(less lus bar prn)))
    ! {1 8}
    ! exit
    ~zod/try=> (scan "sas|-/lo" (star ;~(less lus bar prn)))
    ! {1 5}
    ! exit



***

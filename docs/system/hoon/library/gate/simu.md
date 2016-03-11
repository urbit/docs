### `++simu`

First and second

Parsing composer: if an [`++edge`]() `vex` reflects a failure, fail. Otherwise,
connect `vex` with the following [`++rule`]().

Accepts
-------

`sab` is a `++rule`.

`vex` is an `++edge`.

Produces
--------



Source
------

    ++  simu                                                ::  first and second
      |*  [vex=edge sab=_rule]
      ?~  q.vex
        vex
      =+  roq=(sab)
      roq
    ::

Examples
--------

    ~zod/try=> (scan "~zod" scat:vast)
    [%dtzy p=%p q=0]
    ~zod/try=> (scan "%zod" scat:vast)
    [%dtzz p=%tas q=6.582.138]
    ~zod/try=> (scan "%zod" ;~(simu cen scat:vast))
    [%dtzz p=%tas q=6.582.138]
    ~zod/try=> (scan "~zod" ;~(simu cen scat:vast))
    ! {1 1}
    ! exit



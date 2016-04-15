### `++pose`

Parse options

Parsing composer: if `vex` reflects a failure, connect it with the
following rule `sab`. See also: the monad applicator ;\~

Accepts
-------

`sab` is a `++rule`.

`vex` is an `++edge`.

Produces
--------



Source
------

    ++  pose                                                ::  first or second
      ~/  %pose
      |*  {vex/edge sab/rule}
      ?~  q.vex
        =+  roq=(sab)
        [p=(last p.vex p.roq) q=q.roq]
      vex
    ::


Examples
--------

    ~zod/try=> `@t`(scan "+" ;~(pose lus tar cen))
    '+'
    ~zod/try=> `@t`(scan "*" ;~(pose lus tar cen))
    '*'
    ~zod/try=> `@t`(scan "%" ;~(pose lus tar cen))
    '%'
    ~zod/try=> `@t`(scan "-" ;~(pose lus tar cen))
    ! {1 1}
    ! exit



***

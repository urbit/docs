### `++pfix`

Discard first rule

Parsing composer: connects an [`++edge`]() `vex` with two subsequent [`++rule`]()s,
ignoring the result of the first and producing the result of the second.

Accepts
-------

`vex` is an [edge]().

Produces
--------



Source
------

    ++  pfix                                                ::  discard first rule
      ~/  %pfix
      (comp |*([a=* b=*] b))
    ::

Examples
--------

    ~zod/try=> `@t`(scan "%him" ;~(pfix cen sym))
    'him'
    ~zod/try=> (scan "+++10" ;~(pfix (star lus) dem))
    q=10



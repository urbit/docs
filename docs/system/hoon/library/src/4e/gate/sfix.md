### `++sfix`

Discard second rule

Parsing composer: connects [`++edge`]()s `vex` with two subsequent [`++rule`]()s returning the
result of the first and discarding the result of the second.

Accepts
-------

`a` is the result of parsing the first `++rule`.

`b` is the result of of parsing the second `++rule`.

Produces
--------



Source
------

    ++  sfix                                                ::  discard second rule
      ~/  %sfix
      (comp |*([a=* b=*] a))

Examples
--------

    ~zod/try=> `@t`(scan "him%" ;~(sfix sym cen))
    'him'
    ~zod/try=> (scan "10+++" ;~(sfix dem (star lus)))
    q=10



### `++glue`

Skip delimiter

Parsing composer: connects an `++edge` `vex` with a following `++rule` `sab` by
parsing the `++rule` `bus` (the delimiting symbol) and throwing out the
result.

Accepts
-------

`bus` is a `++rule`.

`sab` is a `++rule`.

`vex` is an `++edge`.

Produces
--------



Source
------

    ++  glue                                                ::  add rule
      ~/  %glue
      |*  bus/rule
      ~/  %fun
      |*  {vex/edge sab/rule}
      (plug vex ;~(pfix bus sab))
    ::

Examples
--------

    ~zod/try=> (scan "200|mal|bon" ;~((glue bar) dem sym sym))
    [q=200 7.102.829 7.237.474]
    ~zod/try=> `[@u @tas @tas]`(scan "200|mal|bon" ;~((glue bar) dem sym sym))
    [200 %mal %bon]
    ~zod/try=>  (scan "200|;|bon" ;~((glue bar) dem sem sym))
    [q=200 ~~~3b. 7.237.474]
    ~zod/try=>  (scan "200.;.bon" ;~((glue dot) dem sem sym))
    [q=200 ~~~3b. 7.237.474]



***

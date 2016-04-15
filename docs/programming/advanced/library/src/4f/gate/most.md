### `++most`

Parse list of at least one match

Parser modifier: parse a `++list` of at least one match using a delimiter `++rule`.

Accepts
-------

`bus` is a `++rule`.

`fel` is a `++rule`.

Produces
--------

A `++rule`.

Source
------

    ++  most
      |*  {bus/rule fel/rule}
      ;~(plug fel (star ;~(pfix bus fel)))
    ::

Examples
--------
    
    ~zod/try=> (scan "40 20" (most ace dem))
    [q=40 ~[q=20]]
    ~zod/try=> (scan "40 20 60 1 5" (most ace dem))
    [q=40 ~[q=20 q=60 q=1 q=5]]
    ~zod/try=> (scan "" (most ace dem))
    ! {1 1}
    ! exit



***

### `++more`

Parse list with delimiter

Parser modifier: Parse a list of matches using a delimiter [`++rule`]().

Accepts
-------

`bus` is a `++rule`.

`fel` is a `++rule`.

Produces
--------

A `++rule`.

Source
------

    ++  more
      |*  [bus=_rule fel=_rule]
      ;~(pose (most bus fel) (easy ~))

Examples
--------
    
    ~zod/try=> (scan "" (more ace dem))
    ~
    ~zod/try=> (scan "40 20" (more ace dem))
    [q=40 ~[q=20]]
    ~zod/try=> (scan "40 20 60 1 5" (more ace dem))
    [q=40 ~[q=20 q=60 q=1 q=5]]



***

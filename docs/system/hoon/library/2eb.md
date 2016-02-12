section 2eB, parsing (tracing)
==============================

### `++last`

Farther trace

Compares two line-column pairs, called [`++hair`]()s, `zyc` and `naz`, producing whichever
is further along.

Accepts
-------

`naz` is a [hair]().

`zyc` is a [hair]().

Produces
--------

a `++hair`.

Source
------

    ++  last  |=  [zyc=hair naz=hair]                       ::  farther trace
              ^-  hair
              ?:  =(p.zyc p.naz)
                ?:((gth q.zyc q.naz) zyc naz)
              ?:((gth p.zyc p.naz) zyc naz)
    ::


Examples
--------

    ~zod/try=> (last [1 1] [1 2])
    [p=1 q=2]
    ~zod/try=> (last [2 1] [1 2])
    [p=2 q=1]
    ~zod/try=> (last [0 0] [99 0])
    [p=99 q=0]
    ~zod/try=> (last [7 7] [7 7])
    [p=7 q=7]

------------------------------------------------------------------------

### `++lust`

Detect newline

Advances the [`++hair`]() `naz` by a row if the [`++char`]() `weq` is a newline, or by a
column if `weq` is any other character.

Accepts
-------

`weq` is a char.

`naz` is a hair.

Produces
--------

A hair.

Source
------

    ++  lust  |=  [weq=char naz=hair]                       ::  detect newline
              ^-  hair
              ?:(=(10 weq) [+(p.naz) 1] [p.naz +(q.naz)])


Examples
--------

    ~zod/try=> (lust `a` [1 1])
    [p=1 q=2]
    ~zod/try=> (lust `@t`10 [1 1])
    [p=2 q=1]
    ~zod/try=> (lust '9' [10 10])
    [p=10 q=11]
    /~zod/try=> (roll "maze" [.(+<+ [1 1])]:lust)
    [1 5]
    /~zod/try=> %-  roll  :_  [.(+<+ [1 1])]:lust
    """
    Sam
    lokes
    """
    [2 6]

------------------------------------------------------------------------

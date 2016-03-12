
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


***

### `++term`

Hoon constants

A restricted text atom for Hoon constants. The only characters permitted are
lowercase ASCII, `-`, and `0-9`, the latter two of which can neither be the first or last
character. The syntax for [`@tas`]() is the text itself, always preceded by `%`.
This means a term is always [cubical](). The empty `@tas` has a special syntax,
`$`.


Source
------

        ++  term  ,@tas                                         ::  Hoon ASCII subset

Examples
--------

    ~zod/try=> *term
    %$

    ~zod/try=> %dead-fish9
    %dead-fish9
    ~zod/try=> -:!>(%dead-fish9)
    [%cube p=271.101.667.197.767.630.546.276 q=[%atom p=%tas]]



***

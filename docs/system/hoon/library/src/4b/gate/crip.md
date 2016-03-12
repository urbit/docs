### `++crip`

Tape to cord

Produce a [`++cord`]() from a [`++tape`]().

Accepts
-------

`a` is a `++tape`.

Produces
--------

A `++cord`.

Source
------

    ++  crip  |=(a=tape `@t`(rap 3 a))                      ::  tape to cord

Examples
--------

    ~zod/try=> (crip "john doe")
    'john doe'
    ~zod/try=> (crip "abc 123 !@#")
    'abc 123 !@#'
    ~zod/try=> `@ud`(crip "abc")
    6.513.249


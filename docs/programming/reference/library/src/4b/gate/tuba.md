### `++tuba`

UTF8 to UTF32 tape

Convert `++tape` to a `++list` of codepoints (`@c`).

Accepts
-------

`a` is a `++tape`.

Produces
--------

A `++list` of codepoints `@c`.

Source
------

    ++  tuba                                                ::  utf8 to utf32 tape
      |=  a/tape
      ^-  (list @c)
      (rip 5 (turf (rap 3 a)))                              ::  XX horrible
    ::

Examples
--------

    /~zod/try=> (tuba "я тут")
    ~[~-~44f. ~-. ~-~442. ~-~443. ~-~442.]
    /~zod/try=> (tuba "chars")
    ~[~-c ~-h ~-a ~-r ~-s]



***

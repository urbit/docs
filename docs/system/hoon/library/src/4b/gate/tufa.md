### `++tufa`

UTF32 to UTF8 tape

Wrap a [`++list`]() of utf32 codepoints into a utf8 [`++tape`]().

Accepts
-------

`a` is a `++list` of [`@c`]().

Produces
--------

A `++tape`.

Source
------

    ++  tufa                                                ::  utf32 to utf8 tape
      |=  a=(list ,@c)
      ^-  tape
      ?~  a  ""
      (weld (rip 3 (tuft i.a)) $(a t.a))
    ::

Examples
--------

    /~zod/try=> (tufa ~[~-~44f. ~-. ~-~442. ~-~443. ~-~442.])
    "я тут"
    /~zod/try=> (tufa ((list ,@c) ~[%a %b 0xb1 %c]))
    "ab±c"



***

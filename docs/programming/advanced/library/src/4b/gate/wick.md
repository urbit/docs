### `++wick`

Coin format decode

Unescape `++span` `~~` as `~` and `~-` as `_`.

Accepts
-------

`a` is a an atom.

Produces
--------

A `++span` `@ta`.

Source
------

    ++  wick                                                ::  knot format
      |=  a/@
      ^-  (unit @ta)
      =+  b=(rip 3 a)
      =-  ?^(b ~ (some (rap 3 (flop c))))
      =|  c/tape
      |-  ^-  {b/tape c/tape}
      ?~  b  [~ c]
      ?.  =('~' i.b)
        $(b t.b, c [i.b c])
      ?~  t.b  [b ~]
      ?-  i.t.b
        $'~'  $(b t.t.b, c ['~' c])
        $'-'  $(b t.t.b, c ['_' c])
        @     [b ~]
      ==
    ::

Examples
--------

    /~zod/try=> `@t`(wick '~-ams~~lop')
    '_ams~lop'
    /~zod/try=> `@t`(wick (wack '~20_sam~'))
    '~20_sam~'



***

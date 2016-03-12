### `++wick`

Coin format decode

Unescape [`++span`]() `~~` as `~` and `~-` as `_`.

Accepts
-------

`a` is a an [atom]().

Produces
--------

A [`++span`]() `@ta`.

Source
------

    ++  wick                                                ::  coin format
      |=  a=@
      ^-  @ta
      =+  b=(rip 3 a)
      %+  rap  3
      |-  ^-  tape
      ?~  b
        ~
      ?:  =('~' i.b)
        ?~  t.b  !!
        [?:(=('~' i.t.b) '~' ?>(=('-' i.t.b) '_')) $(b t.t.b)]
      [i.b $(b t.b)]
    ::

Examples
--------

    /~zod/try=> `@t`(wick '~-ams~~lop')
    '_ams~lop'
    /~zod/try=> `@t`(wick (wack '~20_sam~'))
    '~20_sam~'



***

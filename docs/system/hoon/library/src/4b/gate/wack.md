### `++wack`

Coin format encode

Escape [`++span`]() `~` as `~~` and `_` as `~-`. Used for printing.

Accepts
-------

`a` is a `++span` (`@ta`).

Produces
--------

A [`++span`]() (`@ta`).

Source
------

    ++  wack                                                ::  coin format
      |=  a=@ta
      ^-  @ta
      =+  b=(rip 3 a)
      %+  rap  3
      |-  ^-  tape
      ?~  b
        ~
      ?:  =('~' i.b)  ['~' '~' $(b t.b)]
      ?:  =('_' i.b)  ['~' '-' $(b t.b)]
      [i.b $(b t.b)]
    ::

Examples
--------

    /~zod/try=> (wack '~20_sam~')
    ~.~~20~-sam~~
    /~zod/try=> `@t`(wack '~20_sam~')
    '~~20~-sam~~'
    ~zod/try=> ~(rend co %many ~[`ud/5 `ta/'~20_sam'])
    "._5_~~.~~20~-sam__"
    ~zod/try=> ._5_~~.~~20~-sam__
    [5 ~.~20_sam]



***

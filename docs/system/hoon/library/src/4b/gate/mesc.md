### `++mesc`

Escape special chars

Escape special characters, used in [`++show`](/doc/hoon/library/2ez#++show)

Accepts
-------

`vib` is a [`++tape`]().

Produces
--------

A `++tape`.

Source
------

    ++  mesc                                                ::  ctrl code escape
      |=  vib=tape
      ^-  tape
      ?~  vib
        ~
      ?:  =('\\' i.vib)
        ['\\' '\\' $(vib t.vib)]
      ?:  ?|((gth i.vib 126) (lth i.vib 32) =(39 i.vib))
        ['\\' (welp ~(rux at i.vib) '/' $(vib t.vib))]
      [i.vib $(vib t.vib)]
    ::

Examples
--------

    /~zod/try=> (mesc "ham lus")
    "ham lus"
    /~zod/try=> (mesc "bas\\hur")
    "bas\\\\hur"
    /~zod/try=> (mesc "as'saß")
    "as\0x27/sa\0xc3/\0x9f/"



***

### `++teff`

UTF8 Length

Produces the number of utf8 bytes.

Accepts
-------

`a` is a [`@t`]().

Produces
--------

An atom.

Source
------

    ++  teff                                                ::  length utf8
      |=  a=@t  ^-  @
      =+  b=(end 3 1 a)
      ?:  =(0 b)
        ?>(=(0 a) 0)
      ?>  |((gte b 32) =(10 b))
      ?:((lte b 127) 1 ?:((lte b 223) 2 ?:((lte b 239) 3 4)))
    ::

Examples
--------

    /~zod/try=> (teff 'a')
    1
    /~zod/try=> (teff 'ß')
    2



***

### `++chum`

Jet hint information

Jet hint information that must be present in the body of a `~/` or `~%`
rune. A `++chum` can optionally contain a kelvin version, jet vendor,
and "{major}.{minor}" version number.

Source
------

    ++  chum  $?  lef=term                                  ::  jet name
                  [std=term kel=@]                          ::  kelvin version
                  [ven=term pro=term kel=@]                 ::  vendor and product
                  [ven=term pro=term ver=@ kel=@]           ::  all of the above
              ==                                            ::

Examples
--------

XX there's a ++chum in zuse that's politely causing this not to work

    ~zod/try=> `chum`'hi'
    lef=%hi

    ~zod/try=> (ream '~/(%lob.314 !!)')
    [%sgfs p=[std=%lob kel=314] q=[%zpzp ~]]



***

### `++trim`

Tape split

Split first `a` characters off `++tape` `b`.

Accepts
-------

`a` is an atom.

`b` is a `++tape`.

Produces
--------

A cell of `++tape`s, `p` and `q`.

Source
------

      ++  trim                                              ::  31-bit nonzero
        |=  key/@
        =+  syd=0xcafe.babe
        |-  ^-  @
        =+  haz=(spec syd key)
        =+  ham=(mix (rsh 0 31 haz) (end 0 31 haz))
        ?.(=(0 ham) ham $(syd +(syd)))
      --
    ::


Examples
--------

    /~zod/try=> (trim 5 "lasok termun")
    [p="lasok" q=" termun"]
    /~zod/try=> (trim 5 "zam")
    [p="zam" q=""]



***

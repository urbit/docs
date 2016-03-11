### `++trim`

Tape split

Split first `a` characters off [`++tape`]() `b`.

Accepts
-------

`a` is an atom.

`b` is a `++tape`.

Produces
--------

A cell of `++tape`s, `p` and `q`.

Source
------

    ++  trim                                                ::  tape split
      |=  [a=@ b=tape]
      ^-  [p=tape q=tape]
      ?~  b
        [~ ~]
      ?:  =(0 a)
        [~ b]
      =+  c=$(a (dec a), b t.b)
      [[i.b p.c] q.c]
    ::

Examples
--------

    /~zod/try=> (trim 5 "lasok termun")
    [p="lasok" q=" termun"]
    /~zod/try=> (trim 5 "zam")
    [p="zam" q=""]



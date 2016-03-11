### `++runt`

Prepend `n` times

Add `a` repetitions of character `b` to the head of [`++tape`]() `c`.

Accepts
-------

`a` and `b` are atoms.

`c` is a `++tape`.

Produces
--------

A `++tape`.

Source
------

    ++  runt                                                ::  prepend repeatedly
      |=  [[a=@ b=@] c=tape]
      ^-  tape
      ?:  =(0 a)
        c
      [b $(a (dec a))]
    ::

Examples
--------

    /~zod/try=> (runt [2 '/'] "ham")
    "//ham"
    /~zod/try=> (runt [10 'a'] "")
    "aaaaaaaaaa"



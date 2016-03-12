### `++rash`

Parse or crash

Parse a cord with a given [`++rule`]() and crash if the [`++cord`]() isn't entirely
parsed.

Accepts
-------

`naf` is an atom.

`sab` is a `++rule`.

Produces
--------

The value of the parse result, or crash.

Source
------

    ++  rash  |*([naf=@ sab=_rule] (scan (trip naf) sab))   ::

Examples
--------

    ~zod/try=> (rash 'I was the world in which I walked, and what I saw' (star (shim 0 200)))
    "I was the world in which I walked, and what I saw"
    ~zod/try=> (rash 'abc' (just 'a'))
    ! {1 2}
    ! 'syntax-error'
    ! exit
    ~zod/try=> (rash 'abc' (jest 'abc'))
    'abc'
    `~zod/try=> (rash 'abc' (jest 'ab'))
    ! {1 3}
    ! 'syntax-error'
    ! exit



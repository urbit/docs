### `++scan`

Parse tape or crash

Parse a `++tape` with a given `++rule` and crash if the `++tape` isn't entirely
parsed.

Accepts
-------

`los` is a tape.

`sab` is a rule.

Produces
--------

Either a `++tape` or a crash.

Source
------

    ++  scan  |*  {los/tape sab/rule}
              =+  vex=((full sab) [[1 1] los])
              ?~  q.vex
                ~_  (show [%m '{%d %d}'] p.p.vex q.p.vex ~)
                ~|('syntax-error' !!)
              p.u.q.vex

Examples
--------

        ~zod/try=> (scan "I was the world in which I walked, and what I saw" (star (shim 0 200)))
        "I was the world in which I walked, and what I saw"
        ~zod/try=> (scan "Or heard or felt came not but from myself;" (star (shim 0 200)))
        "Or heard or felt came not but from myself;"
        ~zod/try=> (scan "And there I found myself more truly and more strange." (jest 'And there I'))
        ! {1 12}
        ! 'syntax-error'
        ! exit


***

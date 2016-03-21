### `++rust`

Parse tape or null

Parse a `++tape` with a given `++rule` and produce null if the `++tape` isn't
entirely parsed.

Accepts
-------

`los` is a `++tape`.

`sab` is a `++rule`.

Produces
--------

A `(unit ,@t)`

Source
------

    ++  rust  |*  {los/tape sab/rule}
              =+  vex=((full sab) [[1 1] los])
              ?~(q.vex ~ [~ u=p.u.q.vex])


Examples
--------

        ~zod/try=> (rust "I was the world in which I walked, and what I saw" (star (shim 0 200)))
        [~ "I was the world in which I walked, and what I saw"]
        ~zod/try=> (rust "Or heard or felt came not but from myself;" (star (shim 0 200)))
        [~ "Or heard or felt came not but from myself;"]
        ~zod/try=> (rust "And there I found myself more truly and more strange." (jest 'And there I'))
        ~



***

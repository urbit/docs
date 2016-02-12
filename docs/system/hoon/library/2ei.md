section 2eI, parsing (external)
===============================

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

------------------------------------------------------------------------

### `++rush`

Parse or null

Parse a given with a given rule and produce null if the cord isn't
entirely parsed.

Accepts
-------

`naf` is an [atom]().

`sab` is a [rule]().

Produces
--------

The value of the parse result, or null.

Source
------

    ++  rush  |*([naf=@ sab=_rule] (rust (trip naf) sab))

Examples
--------

        ~zod/try=> (rush 'I was the world in which I walked, and what I saw' (star (shim 0 200)))
        [~ "I was the world in which I walked, and what I saw"]
        ~zod/try=> (rush 'abc' (just 'a'))
        ~
        ~zod/try=> (rush 'abc' (jest 'abc'))
        [~ 'abc']
        ~zod/try=> (rush 'abc' (jest 'ac'))
        ~
        ~zod/try=> (rush 'abc' (jest 'ab'))
        ~

------------------------------------------------------------------------

### `++rust`

Parse tape or null

Parse a [`++tape`]() with a given [`++rule`]() and produce null if the `++tape` isn't
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

    ++  rust  |*  [los=tape sab=_rule]
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

------------------------------------------------------------------------

### `++scan`

Parse tape or crash

Parse a [`++tape`]() with a given [`++rule`]() and crash if the `++tape` isn't entirely
parsed.

Accepts
-------

`los` is a [tape]().

`sab` is a [rule]().

Produces
--------

Either a `++tape` or a crash.

Source
------

    ++  scan  |*  [los=tape sab=_rule]
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

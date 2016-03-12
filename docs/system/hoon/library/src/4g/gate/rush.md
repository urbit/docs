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



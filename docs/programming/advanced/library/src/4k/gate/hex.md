### `++hex`

Hex to atom

Parse any hexadecimal number to an atom.

Source
------

    ++  hex  (bass 16 (most gon hit))                       ::  hex to atom

Examples
--------

        ~zod/try=> (scan "a" hex)
        10
        ~zod/try=> (scan "A" hex)
        10
        ~zod/try=> (scan "2A" hex)
        42
        ~zod/try=> (scan "1ee7" hex)
        7.911
        ~zod/try=> (scan "1EE7" hex)
        7.911
        ~zod/try=> (scan "1EE7F7" hex)
        2.025.463
        ~zod/try=> `@ux`(scan "1EE7F7" hex)
        0x1e.e7f7


***

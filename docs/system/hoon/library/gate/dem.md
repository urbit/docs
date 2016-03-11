### `++dem`

Decimal to atom

Parse a decimal number to an atom.

Source
------

    ++  dem  (bass 10 (most gon dit))                       ::  decimal to atom

Examples
--------

        ~zod/try=> (scan "7" dem)
        7
        ~zod/try=> (scan "42" dem)
        42
        ~zod/try=> (scan "150000000" dem)
        150.000.000
        ~zod/try=> (scan "12456" dem)
        12.456



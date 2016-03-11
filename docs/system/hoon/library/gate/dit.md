### `++dit`

Decimal digit

Parse a single decimal digit.

Source
------

    ++  dit  (cook |=(a=@ (sub a '0')) (shim '0' '9'))      ::  decimal digit

Examples
--------

        ~zod/try=> (scan "7" dit)
        7
        ~zod/try=> (scan "42" (star dit))
        ~[4 2]
        ~zod/try=> (scan "26000" (star dit))
        ~[2 6 0 0 0]



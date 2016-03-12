### `++hit`

Hex digits

Parse a single hexadecimal digit.

Source
------

    ++  hit  ;~  pose                                       ::  hex digits
               dit
               (cook |=(a=char (sub a 87)) (shim 'a' 'f'))
               (cook |=(a=char (sub a 55)) (shim 'A' 'F'))
             ==

Examples
--------

        ~zod/try=> (scan "a" hit)
        10
        ~zod/try=> (scan "A" hit)
        10
        ~zod/try=> (hit [[1 1] "a"])
        [p=[p=1 q=2] q=[~ [p=10 q=[p=[p=1 q=2] q=""]]]]
        ~zod/try=> (scan "2A" (star hit))
        ~[2 10]


***

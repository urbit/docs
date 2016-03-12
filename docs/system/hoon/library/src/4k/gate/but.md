### `++but`

Binary digit

Parse a single binary digit.

Source
------

    ++  but  (cook |=(a=@ (sub a '0')) (shim '0' '1'))      ::  binary digit

Examples
--------

        ~zod/try=> (scan "0" but)
        0
        ~zod/try=> (scan "1" but)
        1
        ~zod/try=> (scan "01" but)
        ! {1 2}
        ! 'syntax-error'
        ! exit
        ~zod/try=> (scan "01" (star but))
        ~[0 1]



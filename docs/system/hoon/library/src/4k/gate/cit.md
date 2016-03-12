### `++cit`

Octal digit

Parse a single octal digit.

Source
------

    ++  cit  (cook |=(a=@ (sub a '0')) (shim '0' '7'))      ::  octal digit

Examples
--------

        ~zod/try=> (scan "1" cit)
        1
        ~zod/try=> (scan "7" cit)
        7
        ~zod/try=> (scan "8" cit)
        ! {1 1}
        ! 'syntax-error'
        ! exit
        ~zod/try=> (scan "60" (star cit))
        ~[6 0]



***

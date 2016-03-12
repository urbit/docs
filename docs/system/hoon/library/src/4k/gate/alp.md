### `++alp`

Alphanumeric and `-`

Parse alphanumeric strings and hep, "-".

Source
------

    ++  alp  ;~(pose low hig nud hep)                       ::  alphanumeric and -

Examples
--------

        ~zod/try=> (scan "7" alp)
        ~~7
        ~zod/try=> (scan "s" alp)
        ~~s
        ~zod/try=> (scan "123abc-" (star alp))
        "123abc-"



***

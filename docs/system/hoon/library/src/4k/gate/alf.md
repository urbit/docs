### `++alf`

Alphabetic characters

Parse alphabetic characters, both upper and lowercase.

Source
------

    ++  alf  ;~(pose low hig)                               ::  alphabetic

Examples
--------

        ~zod/try=> (scan "a" alf)
        ~~a
        ~zod/try=> (scan "A" alf)
        ~~~41.
        ~zod/try=> (scan "AaBbCc" (star alf))
        "AaBbCc"



***

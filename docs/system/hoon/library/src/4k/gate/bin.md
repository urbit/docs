### `++bin`

Binary to atom

Parse a tape of binary (0s and 1s) and produce its atomic representation.

Source
------

    ++  bin  (bass 2 (most gon but))                        ::  binary to atom

Examples
--------

        ~zod/try=> (scan "0000" bin)
        0
        ~zod/try=> (scan "0001" bin)
        1
        ~zod/try=> (scan "0010" bin)
        2
        ~zod/try=> (scan "100000001111" bin)
        2.063



***

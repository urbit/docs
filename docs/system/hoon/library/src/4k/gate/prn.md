### `++prn`

Printable character

Parse any printable character.

Source
------

    ++  prn  ;~(less (just `@`127) (shim 32 256))

Examples
--------

    ~zod/try=> (scan "h" prn)
    ~~h
    ~zod/try=> (scan "!" prn)
    ~~~21.
    ~zod/try=> (scan "\01" prn)
    ! {1 1}
    ! exit



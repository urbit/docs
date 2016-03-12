### `++qit`

Chars in cord

Parse an individual character to its cord atom representation.

Source
------

    ++  qit  ;~  pose                                       ::  chars in a cord
                 ;~(less bas soq prn)
                 ;~(pfix bas ;~(pose bas soq mes))          ::  escape chars
             ==

Examples
--------

    ~zod/try=> (scan "%" qit)
    37
    ~zod/try=> `@t`(scan "%" qit)
    '%'
    ~zod/try=> (scan "0" qit)
    48
    ~zod/try=> (scan "E" qit)
    69
    ~zod/try=> (scan "a" qit)
    97
    ~zod/try=> (scan "\\0a" qit)
    10
    ~zod/try=> `@ux`(scan "\\0a" qit)
    0xa
    ~zod/try=> (scan "cord" (star qit))
    ~[99 111 114 100]



***

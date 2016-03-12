### `++unit`

Maybe

[mold]() generator. A `++unit` is either `~` or `[~ u=a]` where `a` is the
type that was passed in.


Source
------

        ++  unit  |*  a=_,*                                     ::  maybe

Examples
--------

See also: [`++bind`]()

    ~zod/try=> :type; *(unit time)
    ~
    u(@da)
    ~zod/try=> `(unit time)`[~ -<-]
    [~ ~2014.9.24..19.25.10..7dd5]



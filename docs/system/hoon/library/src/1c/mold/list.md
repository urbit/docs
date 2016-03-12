### `++list`

List

[mold]() generator. `++list` generates a mold of a null-termanated list of a
homogenous type.


Source
------

        ++  list  |*  a=_,*                                     ::  null-term list

Examples
--------

See also: [`++turn`](), [`++snag`]()

    ~zod/try=> *(list)
    ~
    ~zod/try=> `(list ,@)`"abc"
    ~[97 98 99]
    ~zod/try=> (snag 0 "abc")
    ~~a



***

### `++set`

Set

[mold]() generator. A `++set` is a
[treap](http://en.wikipedia.org/wiki/Treap) with unique values.

Source
------

    ++  set  |*  a=_,*                                      ::  set
             $|(~ [n=a l=(set a) r=(set a)])                ::

Examples
--------

See also: [`++in`]()

    ~zod/try=> (sa "abc")
    {~~a ~~c ~~b}
    ~zod/try=> (~(put in (sa "abc")) %d)
    {~~d ~~a ~~c ~~b}
    ~zod/try=> (~(put in (sa "abc")) %a)
    {~~a ~~c ~~b}



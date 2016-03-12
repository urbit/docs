### `++map`

Map

[mold]() generator. A `++map` is a [treap](http://en.wikipedia.org/wiki/Treap) of
key, value pairs.


Source
------

        ++  map  |*  [a=_,* b=_,*]                              ::  associative tree

Examples
--------

See also: [`++by`]()

    ~zod/try=> :type; *(map ,@t ,@u)
    {}
    nlr([p=@t q=@u])
    ~zod/try=> `(map ,@ta ,@ud)`(mo (limo a/1 b/2 ~))
    {[p=~.a q=1] [p=~.b q=2]}



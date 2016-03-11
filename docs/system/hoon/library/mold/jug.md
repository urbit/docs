### `++jug`

[mold]() generator.  A `++jug` is a [`++map`]() of [`++set`]()s.

Source
------

    ++  jug  |*([a=_,* b=_,*] (map a (set b)))              ::  map of sets

Examples
--------

See also: `++ju`, `++by`, `++map`, `++set`

    ~zod/try=> =a (sa (limo [1 2 ~]))
    ~zod/try=> a
    {1 2}
    ~zod/try=> =b (sa (limo [3 4 ~]))
    ~zod/try=> b
    {4 3}
    ~zod/try=> =c (mo (limo [[%a a] [%b b] ~]))
    ~zod/try=> c
    {[p=%a q={1 2}] [p=%b q={4 3}]}
    ~zod/try=> (~(get ju c) %b)
    {4 3}
    ~zod/try=> (~(put ju c) [%b 5])
    {[p=%a q={1 2}] [p=%b q={5 4 3}]}


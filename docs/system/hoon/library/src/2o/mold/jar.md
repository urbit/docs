### `++jar`


Tile generator. A `++jar` is a `++map` of `++list`.

Source
------

    ++  jar  |*({a/$-(* *) b/$-(* *)} (map a (list b)))     ::  map of lists


Examples
--------

See also: `++ja`, `++by`, `++map`, `++list`

    ~zod/try=> =a (limo [1 2 ~])
    ~zod/try=> a
    [i=1 t=[i=2 t=~]]
    ~zod/try=> =b (limo [3 4 ~])
    ~zod/try=> b
    [i=3 t=[i=4 t=~]]
    ~zod/try=> =c (mo (limo [[%a a] [%b b] ~]))
    ~zod/try=> c
    {[p=%a q=[i=1 t=[i=2 t=~]]] [p=%b q=[i=3 t=[i=4 t=~]]]}
    ~zod/try=> (~(get ja c) %a)
    [i=1 t=[i=2 t=~]]
    ~zod/try=> (~(get ja c) %c)
    ~



***

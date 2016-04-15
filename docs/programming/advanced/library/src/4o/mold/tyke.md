### `++tyke`

List of 'maybe' twigs

List of [`++unit`]() [`++twig`](), or gaps left to be inferred, in [`++path`]()
parsing. When you use a path such as `/=main=/pub/src/doc` the path is in fact
a `++tyke`, where the `=` are inferred from your current path.


Source
------

        ++  tyke  (list (unit twig))                            ::

Examples
--------

    ~zod/try=> (scan "/==as=" porc:vast)
    [0 ~[~ ~ [~ [%dtzy p=%tas q=29.537]] ~]]
    ~zod/try=> `tyke`+:(scan "/==as=" porc:vast)
    ~[~ ~ [~ [%dtzy p=%tas q=29.537]] ~]



***

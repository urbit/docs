### `++pair`

Mold of pair of types

[mold]() generator. Produces a tuple of two of the types passed in.


Source
------

        ++  pair  |*([a=$+(* *) b=$+(* *)] ,[p=a q=b])          ::  just a pair


Examples
--------

    ~zod/try=> *(pair bean cord)
    [p=%.y q='']



***

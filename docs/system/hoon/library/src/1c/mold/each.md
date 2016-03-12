### `++each`

Mold of fork between two

[mold]() generator: produces a dicriminated [fork]() between two types.

Source
------

        ++  each  |*([a=$+(* *) b=$+(* *)] $%([& p=a] [| p=b])) ::  either a or b

Examples
--------

    ~zod/try=> :type; *(each cord time)
    [%.y p='']
    {[%.y p=@t] [%.n p=@da]}



***

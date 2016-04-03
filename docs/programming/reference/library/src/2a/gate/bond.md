### `++bond`

Replace null

Replaces an empty ++unit `b` with the product of a called trap
`a`. If the unit is not empty, then the original unit is produced.

Accepts
-------

`a` is a trap.

`b` is a unit.

Produces
--------

Either the product of `a` or the value inside of unit `b`.

Source
------

    ++  bond                                                ::  replace
      |*  a/(trap)
      |*  b/(unit)
      ?~  b  $:a
      u.b


Examples
--------

    ~zod/try=> (bex 10)
    1.024
    ~zod/try=> ((bond |.((bex 10))) ~)
    1.024
    ~zod/try=> ((bond |.((bex 10))) (slaw %ud '123'))
    123



***

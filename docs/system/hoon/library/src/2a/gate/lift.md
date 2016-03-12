### `++lift`

Curried bind

Accepts a [`++gate`]() `a` and produces a function that accepts [`++unit`]()
`b` to which it applies `a`. Used when you want a function that does not accept
or produce a unit to both accept and produce a unit.

Accepts
-------

`a` is a gate.

`b` is a unit.

Produces
--------

A unit.

Source
------

    ++  lift                                                ::  lift gate (fmap)
      |*  a=gate                                            ::  flipped
      |*  b=(unit)                                          ::  curried
      (bind b a)                                            ::  bind

Examples
--------

    ~zod/try=> ((lift dec) `(unit ,@)`~)
    ~
    ~zod/try=> ((lift dec) `(unit ,@)`[~ 20])
    [~ 19]



***

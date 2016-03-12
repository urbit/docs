### `++need`

Unwrap unit

Retrieve the value from a [`++unit`]() and crash if the unit is null.

Accepts
-------

`a` is a unit.

Produces
--------

Either the unwrapped value of `a` (`u.a`), or crash.

Source
------

    ++  need                                                ::  demand
      |*  a=(unit)
      ?~  a  !!
      u.a

Examples
--------

    ~zod/try=> =a ((unit ,[@t @t]) [~ ['a' 'b']])
    ~zod/try=> (need a)
    ['a' 'b']
    ~zod/try=> =a ((unit ,@ud) [~ 17])
    ~zod/try=> (need a)
    17
    ~zod/try=> =a ((unit ,@) [~])
    ~zod/try=> (need a)
    ! exit



***

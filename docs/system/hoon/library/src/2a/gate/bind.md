### `++bind`

Non-unit function to unit, producing unit

Applies a function `b` to the value (`u.a`) of a [++unit]() `a`, producing
a unit. Used when you want a function that does not accept or produce a
unit to both accept and produce a unit.

Accepts
-------

`a` is a unit.

`b` is a function.

Produces
--------

A unit.

Source
------

    ++  bind                                                ::  argue
      |*  [a=(unit) b=gate]
      ?~  a  ~
      [~ u=(b u.a)]

Examples
--------

    ~zod/try=> (bind ((unit ,@) [~ 97]) ,@t)
    [~ `a`]
    ~zod/try=> =a |=(a=@ (add a 1))
    ~zod/try=> (bind ((unit ,@) [~ 2]) a)
    [~ 3]



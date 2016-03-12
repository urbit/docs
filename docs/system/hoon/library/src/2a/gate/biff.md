### `++biff`

Unit as argument

Applies a function `b` that produces a unit to the unwrapped value of [++unit]()
`a` (`u.a`). If `a` is empty, `~` is produced.

Accepts
-------

`a` is a unit.

`b` is a function that accepts a noun and produces a unit.

Produces
--------

A unit.

Source
------

    ++  biff                                                ::  apply
      |*  [a=(unit) b=$+(* (unit))]
      ?~  a  ~
      (b u.a)

Examples
--------

    ~zod/try=> (biff (some 5) |=(a=@ (some (add a 2))))
    [~ u=7]
    ~zod/try=> (biff ~ |=(a=@ (some (add a 2))))
    ~



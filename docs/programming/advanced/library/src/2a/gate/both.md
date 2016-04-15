### `++both`

Group unit values into pair

Produces `~` if either `a` or `b` are empty. Otherwise, produces a
++unit whose value is a cell of the values of two input units `a` and
`b`.

Accepts
-------

`a` is a unit.

`b` is a unit.

Produces
--------

A unit of the two initial values.

Source
------

    ++  both                                                ::  all the above
      |*  {a/(unit) b/(unit)}
      ?~  a  ~
      ?~  b  ~
      [~ u=[u.a u.b]]


Examples
--------

    ~zod/try=> (both (some 1) (some %b))
    [~ u=[1 %b]]
    ~zod/try=> (both ~ (some %b))
    ~


***

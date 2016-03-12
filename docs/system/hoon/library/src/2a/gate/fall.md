### `++fall`

Give unit a default value

Produces a default value `b` for a [`++unit`]() `a` in cases where `a` is null.

Accepts
-------

`a` is a unit.

`b` is a [noun]() that's used as the default value.

Produces
--------

Either a noun `b` or the unwrapped value of unit `a`.

Source
------

    ++  fall                                                ::  default
      |*  [a=(unit) b=*]
      ?~(a b u.a)

Examples
--------

    ~zod/try=> (fall ~ `a`)
    `a`
    ~zod/try=> (fall [~ u=0] `a`)
    0



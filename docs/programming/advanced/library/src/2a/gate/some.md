### `++some`

Wrap value in a unit

Takes any atom `a` and produces a [`++unit`]() with the value set to `a`.

Accepts
-------

`a` is a [noun]().

Produces
--------

A unit.

Source
------

    ++  some                                                ::  lift (pure)
      |*  a=*
      [~ u=a]

Examples
--------

    ~zod/try=> (some [`a` `b`])
    [~ u=[`a` `b`]]
    ~zod/try=> (some &)
    [~ u=%.y]



***

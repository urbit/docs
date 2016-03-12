### `++murn`

Maybe transform

Passes each member of [`++list`]() `a` to [gate]() `b`, which must produce a
[`++unit`]().  Produces a new list with all the results that do not produce
`~`.

Accepts
-------

`a` is a [list]().

`b` is a [gate]() that produces a [unit]().

Produces
--------

A unit.

Source
------

    ++  murn                                                ::  maybe transform
      |*  [a=(list) b=$+(* (unit))]
      |-
      ?~  a  ~
      =+  c=(b i.a)
      ?~  c
        $(a t.a)
      [i=u.c t=$(a t.a)]

Examples
--------

    ~zod/try=> =a |=(a=@ ?.((gte a 2) ~ (some (add a 10))))
    ~zod/try=> (murn (limo [0 1 2 3 ~]) a)
    [i=12 t=[i=13 t=~]]



***

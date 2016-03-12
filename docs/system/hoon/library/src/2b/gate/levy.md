### `++levy`

Logical "and" on list

Computes the Boolean logical "and" on the results of [gate]() `b` applied to each individual element in [`++list`]() `a`.

Accepts
-------

`a` is a list.

`b` is a gate.

Produces
--------

Source
------

    ++  levy
      ~/  %levy                                             ::  all of
      |*  [a=(list) b=_|=(p=* .?(p))]
      |-  ^-  ?
      ?~  a  &
      ?.  (b i.a)  |
      $(a t.a)

Examples
--------

    ~zod/try=> =a |=(a=@ (lte a 1))
    ~zod/try=> (levy (limo [0 1 2 1 ~]) a)
    %.n
    ~zod/try=> =a |=(a=@ (lte a 3))
    ~zod/try=> (levy (limo [0 1 2 1 ~]) a)
    %.y



***

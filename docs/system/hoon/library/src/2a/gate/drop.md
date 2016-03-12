### `++drop`

Unit to list

Makes a [++list]() of the unwrapped value (`u.a`) of a [`++unit`]() `a`.

Accepts
-------

`a` is a unit.

Produces
--------

A list.

Source
------

    ++  drop                                                ::  enlist
      |*  a=(unit)
      ?~  a  ~
      [i=u.a t=~]

Examples
--------

    ~zod/try=> =a ((unit ,@) [~ 97])
    ~zod/try=> (drop a)
    [i=97 t=~] 
    ~zod/try=> =a ((unit ,@) [~])
    ~zod/try=> (drop a)
    ~



***

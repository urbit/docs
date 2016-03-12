### `++limo`

List Constructor

Turns a null-terminated tuple into a [`++list`]().

Accepts
-------

`a` is a null-terminated tuple.

Produces
--------

A list

Source
------

    ++  limo                                                ::  listify
      |*  a=*
      ^+  =<  $
        |%  +-  $  ?~(a ~ ?:(_? i=-.a t=$ $(a +.a)))
        --
      a

Examples
--------

    ~zod/try=> (limo [1 2 3 ~])
    [i=1 t=[i=2 t=[i=3 t=~]]]



***

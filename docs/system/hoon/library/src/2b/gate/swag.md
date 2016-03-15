### `++swag`

Infix

Similar to `substr` in Javascript: extracts a string infix, beginning at
inclusive index `a`, producing `b` number of characters.

Accepts
-------

`c` is a list.

Produces
--------

A list of the same type as `c`.

Source
------

    ++  swag                                                ::  infix
      |*  {{a/@ b/@} c/(list)}
      (scag +<-> (slag +<-< c))


Examples
--------

    ~zod/try=> (swag [2 5] "roly poly")
    "ly po"
    ~zod/try=> (swag [2 2] (limo [1 2 3 4 ~]))
    [i=3 t=[i=4 t=~]]



***

### `++clap`

Apply function to two units

Applies a binary function `c`--which does not usually accept or produce a [`++unit`]()--
to the values of two units, `a` and `b`, producing a unit.

Accepts
-------

`a` is a unit.

`b` is a unit.

`c` is a function that performs a binary operation.

Produces
--------

A unit.

Source
------

    ++  clap                                                ::  combine
      |*  [a=(unit) b=(unit) c=_|=(^ +<-)]
      ?~  a  b
      ?~  b  a
      [~ u=(c u.a u.b)]

Examples
--------

    ~zod/try=> =u ((unit ,@t) [~ 'a'])
    ~zod/try=> =v ((unit ,@t) [~ 'b'])
    ~zod/try=> (clap u v |=([a=@t b=@t] (welp (trip a) (trip b))))
    [~ u="ab"] 
    ~zod/try=> =a ((unit ,@u) [~ 1])
    ~zod/try=> =b ((unit ,@u) [~ 2])
    ~zod/try=> =c |=([a=@ b=@] (add a b))
    ~zod/try=> (clap a b c)
    [~ 3]
      


***

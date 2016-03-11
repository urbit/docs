### `++scag`

Prefix

Accepts an atom `a` and [list]() `b`, producing the first `a` elements of
the front of the list.

Accepts
-------

`b` is a list.

Produces
--------

A list of the same type as `b`.

Source
------

    ++  scag                                                ::  prefix
      ~/  %scag
      |*  [a=@ b=(list)]
      |-  ^+  b
      ?:  |(?=(~ b) =(0 a))  ~
      [i.b $(b t.b, a (dec a))]

Examples
--------

    ~zod/try=> (scag 2 (limo [0 1 2 3 ~]))
    [i=0 t=[i=1 t=~]]
    ~zod/try=> (scag 10 (limo [1 2 3 4 ~]))
    [i=1 t=[i=2 t=[i=3 t=[i=4 t=~]]]]



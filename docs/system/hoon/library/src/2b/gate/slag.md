### `++slag`

Suffix

Accepts an atom `a` and list `b`, producing the remaining elements from
`b` starting at `a`.

Accepts
-------

`b` is a [list]().

Produces
--------

A list of the same type as `b`.

Source
------

    ++  slag                                                ::  suffix
      ~/  %slag
      |*  [a=@ b=(list)]
      |-  ^+  b
      ?:  =(0 a)  b
      ?~  b  ~
      $(b t.b, a (dec a))

Examples
--------

    ~zod/try=> (slag 2 (limo [1 2 3 4 ~]))
    [i=3 t=[i=4 t=~]]
    ~zod/try=> (slag 1 (limo [1 2 3 4 ~]))
    [i=2 t=[i=3 t=[i=4 t=~]]]



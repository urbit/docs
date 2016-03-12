### `++turn`

Gate to list

Accepts a [`++list`]() `a` and a [gate]() `b`. Produces a list with the gate applied
to each element of the original list.

Accepts
-------

`b` is a gate.

Produces
--------

A list.

Source
------

    ++  turn                                                ::  transform
      ~/  %turn
      |*  [a=(list) b=_,*]
      |-
      ?~  a  ~
      [i=(b i.a) t=$(a t.a)]

Examples
--------

    ~zod/try=> (turn (limo [104 111 111 110 ~]) ,@t)
    <|h o o n|>
    ~zod/try=> =a |=(a=@ (add a 4))
    ~zod/try=> (turn (limo [1 2 3 4 ~]) a)
    ~[5 6 7 8]



***

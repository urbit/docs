### `++reel`

Right fold

Right fold: moves right to left across a `++list` `a`, recursively slamming
a binary gate `b` with an element from `a` and an accumulator, producing
the final value of the accumulator.

Accepts
-------

`b` is a binary gate.

Produces
--------

The accumulator, which is a noun.

Source
------

    ++  reel                                                ::  right fold
      ~/  %reel
      |*  {a/(list) b/_|=({* *} +<+)}
      |-  ^+  +<+.b
      ?~  a
        +<+.b
      (b i.a $(a t.a))


Examples
--------

    ~zod/try=> =sum =|([p=@ q=@] |.((add p q)))
    ~zod/try=> (reel (limo [1 2 3 4 5 ~]) sum)
    15
    ~zod/try=> =a =|([p=@ q=@] |.((sub p q)))
    ~zod/try=> (reel (limo [6 3 1 ~]) a)
    4
    ~zod/try=> (reel (limo [3 6 1 ~]) a)
    ! subtract-underflow
    ! exit



***

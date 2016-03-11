### `++roll`

Left fold

Left fold: moves left to right across a list `a`, recursively slamming a
binary [gate]() `b` with an element from the [`++list`]() and an accumulator,
producing the final value of the accumulator.

Accepts
-------

`b` is a binary [gate]().

Produces
--------

The accumulator, which is a [noun]().

Source
------

    ++  roll                                                ::  left fold
      ~/  %roll
      |*  [a=(list) b=_|=([* *] +<+)]
      |-  ^+  +<+.b
      ?~  a
        +<+.b
      $(a t.a, b b(+<+ (b i.a +<+.b)))

Examples
--------

    ~zod/try=> =sum =|([p=@ q=@] |.((add p q)))
    ~zod/try=> (roll (limo [1 2 3 4 5 ~]) sum)
    q=15
    ~zod/try=> =a =|([p=@ q=@] |.((sub p q)))
    ~zod/try=> (roll (limo [6 3 1 ~]) a)
    ! subtract-underflow
    ! exit
    ~zod/try=> (roll (limo [1 3 6 ~]) a)
    q=4



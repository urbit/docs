### `++cork`

Build `f` such that `(f x) .= (b (a x))`.

`a` is a noun.

`b` is a gate.

Source
------

    ++  cork  |*({a/_|=(* **) b/gate} (corl b a))           ::  compose forward


Examples
--------

    ~zod/try=> (:(cork dec dec dec) 20)
    17
    ~zod/try=> =mal (mo (limo a+15 b+23 ~))
    ~zod/try=> ((cork ~(got by mal) dec) %a)
    14
    ~zod/try=> ((cork ~(got by mal) dec) %b)
    22



***

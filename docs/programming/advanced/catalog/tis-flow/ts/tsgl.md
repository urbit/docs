# `:rap`, `=<`, "tisgal" `{$rap p/twig q/twig}`

Inverted `=>`: `q` as subject of `p`.

Uses the product of `q` as the subject of formula
`p`. Allows us to keep the heavier of `p` `q` as the bottom expression, which
makes for more readable code. Please see the syntax section for more detail.

Regular form: *2-fixed*

Examples:


    ~zod:dojo> b:[a=1 b=2 c=3]
    2
    ~zod:dojo> [. .]:(add 2 4)
    [6 6]

In this simple example we first produce `b` from the tuple
`[a=1 b=2 c=3]` using the irregular form of `=<`. Then we use `.` to
produce our context from the computation `(add 2 4)` as a cell, `[6 6]`.

    ~zod:dojo> =<  lom
               |%
               ++  lom  (add 2 tak)
               ++  tak  4
               --
    6

This example is a more common case, where we want to pull some specific
value out of a longer computation. Here we use the tall form of `=<` to
pull the arm `lom` from the core created with `|%`.

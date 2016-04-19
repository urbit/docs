# `:conl`, `:~`, "colsig", `{$conl p/(list twig)}`
===========

Null-terminated tuple of n elements.

Produces: tuple of input elements. Closed with `==` in tall form.

Regular form: *running*

Examples:

    /~zod:dojo> :~(5 3 4 2 1)
    [5 3 4 2 1 ~]
    /~zod:dojo> ~[5 3 4 2 1]
    [5 3 4 2 1 ~]
    /~zod:dojo> :~  5
                    3
                    4
                    2
                    1
                ==
    [5 3 4 2 1 ~]

This is the most straightforward case of `:~`, producing a tuple in wide, irregular and tall form.

    /~zod:dojo> %-  flop
                %-  limo
                :~  5
                    3
                    4
                    2
                    1
                    ==
    ~[1 2 4 3 5]

In this example we use `%-` to pass the results of our previous example
to `++limo`, which creates a `++list`, and `++flop`, which
reverses its order. This example shows how `:~` is commonly useful.
Null-terminated tuples are easily converted to lists, which are
frequently encountered in hoon.

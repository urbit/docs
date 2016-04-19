# `:cast`, `^-`, "kethep", `{$cast p/twig q/twig}`

Cast.

Casts `q` to the span of `p`. The same as `^+`, except for that `q` is actually cast to the bunt of `q` (`$,(q)`). The easiest way to make a basic cast; used when you already have already created a validator function (mold) for a span.

Regular form: *2-fixed*

Irregular form:


    `p`q   ^-(p q)


Examples:

    ~zod:dojo> (add 90 7)
    97
    ~zod:dojo> `@t`(add 90 7)
    'a'
    ~zod:dojo> ^-(@t (add 90 7))
    'a'

Here we see a straightforward use of `^-` in both irregular and wide
forms, simply casting an atom to a `@t`. `97` is the ASCII code for
`'a'`.

    /~zod:dojo> =cor  |=  a/@
          ^-  (unit @ta)
          [~ u=a]
    new var %cor
    /~zod:dojo> (cor 97)
    [~ ~.a]

In this case we see a very common use of `^-`, at the top of a function.
This pattern is considered good hoon style for two reasons: it gives the
reader a clear pattern for understanding what your code produces, and it
helps ensure type-safety.

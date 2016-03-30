# `:ward`, `^.`, "ketdot", `{$ward p/twig q/twig}`

Cast `q` to product type of `p`.

Casts `q` to the product of calling `p` on `q`. The same
as casting `q` to the product type of `p`. Useful when you want
to cast to the type of a function that you don't want to actually
run at runtime.

Regular form: *2-fixed*

Examples:

    /~zod/try=> =cor  |=  [~ a/@]
          [~ p=a]
    changed %cor
    /~zod/try=> ^.(cor [~ 97])
    [~ p=97]

In this example we create a function `cor` that takes a cell of `~` and an
atom and produces `[~ p=a]`. Using `^.` we can cast without calling
`cor` and produce the same result.

# `:scon`, `:_`, "colcab", `{$scon p/twig q/twig}`

Inverted tuple of `p` `q`.

Produces: a cell of `[q p]`. Exists for code readability and organization. See the backstep convention.

Regular form: *2-fixed*

Examples:

    ~zod/try=> :_(1 2)
    [2 1]

A simple example. `:_` produces the cell of any two twigs, but in
reverse order.

    ~zod/try=> `tape`:_(~ 'a')
    "a"

Since a `++tape` is a null-terminated list of characters, casting
the result of `:_(~ 'a')` to a `tape` produces `"a"`.

    /~zod/try=> 
        :_  (add 2 2)
        |-  (div 4 2)
    [2 4]

Most commonly `:_` helps to organize code, allowing you to produce a
cell from nested computation.

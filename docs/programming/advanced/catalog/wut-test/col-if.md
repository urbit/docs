# `if`, `?:`, "wutcol" `{$if p/twig q/twig r/twig}`

If-then-else.

If `p` evaluates to true, then `q`. Else, `e`.

Regular form: *3-fixed*

Examples:

    ~zod:dojo> ?:((gth 1 2) 1 2)
    2
    ~zod:dojo> ?:(?=(%a 'a') %yup %not-a)
    %yup

Here we see two common cases of `?:` in the wide form, one uses an
expression `++gte` that produces a boolean and the other `?=` to
produce one of its cases.

# `:and`, `?&`, "wutpam" `{$and p/(list twig)}`

Logical 'and'.

Computes the logical 'and' operation on a list of boolean expressions `p`.

Regular form: *running*

Irregular form:

`&(a b c)   ?&(a b c)`

Examples:

    ~zod/try=> ?&(& &)
    %.y
    ~zod/try=> &(& &)
    %.y
    ~zod/try=> &(& |)
    %.n
    ~zod/try=> &((gth 2 1) |)
    %.n
    ~zod/try=> &((gth 2 1) &)
    %.y

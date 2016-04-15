# `:and`, `?&`, "wutpam" `{$and p/(list twig)}`

Logical 'and'.

Computes the logical 'and' operation on a list of boolean expressions `p`.

Regular form: *running*

Irregular form:

`&(a b c)   ?&(a b c)`

Examples:

    ~zod:dojo> ?&(& &)
    %.y
    ~zod:dojo> &(& &)
    %.y
    ~zod:dojo> &(& |)
    %.n
    ~zod:dojo> &((gth 2 1) |)
    %.n
    ~zod:dojo> &((gth 2 1) &)
    %.y

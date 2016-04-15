# `:or`, `?|`, "wutbar" `{$or p/(list twig)}`

Logical 'or'.

Computes the logical 'or' operation on a list of boolean expressions `p`.

Regular form: *running*

Irregular form:

`?(a b c)   ?|(a b c)`

Examples:

    ~zod:dojo> ?|(& |)
    %.y
    ~zod:dojo> |(& |)
    %.y
    ~zod:dojo> |(| |)
    %.n
    ~zod:dojo> (gth 2 1)
    %.y
    ~zod:dojo> |((gth 2 1) |)
    %.y
    ~zod:dojo> |((gth 1 2) |)
    %.n
    ~zod:dojo> |((gth 2 1) &)
    %.y
    ~zod:dojo> |((gth 1 2) &)
    %.y

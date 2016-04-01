# `:or`, `?|`, "wutbar" `{$or p/(list twig)}`

Logical 'or'.

Computes the logical 'or' operation on a list of boolean expressions `p`.

Regular form: *running*

Irregular form:

`?(a b c)   ?|(a b c)`

Examples:

    ~zod/try=> ?|(& |)
    %.y
    ~zod/try=> |(& |)
    %.y
    ~zod/try=> |(| |)
    %.n
    ~zod/try=> (gth 2 1)
    %.y
    ~zod/try=> |((gth 2 1) |)
    %.y
    ~zod/try=> |((gth 1 2) |)
    %.n
    ~zod/try=> |((gth 2 1) &)
    %.y
    ~zod/try=> |((gth 1 2) &)
    %.y

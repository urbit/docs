# `:tow`, `=~`, "tissig" `{$tow p/(list twig)}`
====

List of twigs.

Composes a list of twigs. Applies `=>` to a list of expressions, using each result as the
subject to the following expression.

Regularm form: *running*

Examples:

    ~zod:dojo> =~(1 +(.) +(.))
    3
    ~zod:dojo> =~([1 2] [. [3 4]] [. [5 6]] [. ~])
    [[[[1 2] 3 4] 5 6] ~]

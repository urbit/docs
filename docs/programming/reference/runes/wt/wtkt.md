# `:ifcl`, `?^`, "wutket" `{$ifcl p/wing q/twig r/twig}`
====

If `p` is cell-then-else.

If `p` is a cell, then produce `q`. Else, produce `r`.

Regular form: *3-fixed*

Examples:

    ~zod/try=> =(*@tas "")
    %.y
    ~zod/try=> ?^  ""
                 %full
               %empty
    %empty
    ~zod/try=> ?^  "asd"
                 %full
               %empty
    %full

Here we show that `*@tas`, the bunt of `@tas` is equivalent to the empty
`++tape` `""`, then use it in two `?^` cases.

    ~zod/try=> *(unit)
    ~
    ~zod/try=> ?^  `(unit)`~
                 %full
               %empty
    %empty
    ~zod/try=> ?^  `(unit)`[~ u=20]
                 %full
               %empty
    %full

Similar to the above case, we show the bunt of a `++unit`, which is
`~`, and test against it.


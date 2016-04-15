# `:ifcl`, `?^`, "wutket" `{$ifcl p/wing q/twig r/twig}`
====

If `p` is cell-then-else.

If `p` is a cell, then produce `q`. Else, produce `r`.

Regular form: *3-fixed*

Examples:

    ~zod:dojo> =(*@tas "")
    %.y
    ~zod:dojo> ?^  ""
                 %full
               %empty
    %empty
    ~zod:dojo> ?^  "asd"
                 %full
               %empty
    %full

Here we show that `*@tas`, the bunt of `@tas` is equivalent to the empty
`++tape` `""`, then use it in two `?^` cases.

    ~zod:dojo> *(unit)
    ~
    ~zod:dojo> ?^  `(unit)`~
                 %full
               %empty
    %empty
    ~zod:dojo> ?^  `(unit)`[~ u=20]
                 %full
               %empty
    %full

Similar to the above case, we show the bunt of a `++unit`, which is
`~`, and test against it.


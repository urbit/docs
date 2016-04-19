# `:conq`, `:^`, "colket", `{$conq p/twig q/twig r/twig s/twig}`

Tuple of four.

Produces: the tuple of `[p q r s]`.

Regular form: *4-fixed*

Examples

    /~zod:dojo> :^(1 2 3 4)
    [1 2 3 4]
    /~zod:dojo> :^  5  6
                  7
                8
    [5 6 7 8]

These are the most straightforward cases of `:^`, producing a tuple of four
values in both tall and wide forms respectively.

    /~zod:dojo> 
    :^  (add 2 4)  (add 2 6)
      |-  (div 4 2)
      ~
    [6 8 2 ~]

Most commonly `:^` helps to organize code, allowing you to produce a
cell from nested computation.

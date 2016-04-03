# `:cont`, `:+`, "collus", `{$cont p/twig q/twig r/twig}`
===========

Tuple of 3.

Produces: the tuple of `p`, `q`, and `r`.

Regular form:

*3-fixed*

Examples:

    /~zod/try=> :+  1
                  2
                3
    [1 2 3]
    /~zod/try=> :+(%a ~ 'b')
    [%a ~ 'b']

This is the most straightforward case of `:+`, producing a tuple of three
values in both tall and wide form.

    /~zod/try=> 
    :+  (add 2 4)  (add 2 6)
      |-  (div 4 2)
    [6 8 2]

Most commonly `:+` helps to organize code, allowing you to produce a
cell from nested computation.

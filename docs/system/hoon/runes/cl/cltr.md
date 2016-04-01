# `:conp`, `:*`, "coltar", {$conp p/(list twig)}

Tuple of n elements.

Produces: tuple of input elements. Closed with `==`.

Regular form: *running*

Examples
--------

    /~zod/try=> :*(5 3 4 1 4 9 0 ~ 'a')
    [5 3 4 1 4 9 0 ~ 'a']
    /~zod/try=> [5 3 4 1 4 9 0 ~ 'a']
    [5 3 4 1 4 9 0 ~ 'a']
    /~zod/try=> :*  5
                    3
                    4 
                    1
                    4
                    9
                    0
                    ~
                    'a'
                ==
    [5 3 4 1 4 9 0 ~ 'a']

This is the most straightforward case of `:*`, producing tuples of n
values in wide, irregular and tall forms.

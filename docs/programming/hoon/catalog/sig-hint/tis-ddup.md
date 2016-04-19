# `:ddup`, `~=` "sigtis", `{$ddup p/twig q/twig}`

Hint to avoid duplication.

Hints to the interpreter that `q` may produce a noun equal to the
already existing `p` in order to avoid storing the same noun twice.

Regular form: *2-fixed*

Examples:

    ~zod:dojo> 20
    20
    ~zod:dojo> =+(a=20 20)
    20
    ~zod:dojo> =+(a=20 ~=(a 20))
    20
    ~zod:dojo> (make '=+(a=20 20)')
    [%8 p=[%1 p=20] q=[%1 p=20]]
    ~zod:dojo> (make '=+(a=20 ~=(a 20))')
    [%8 p=[%1 p=20] q=[%10 p=[p=1.836.213.607 q=[%0 p=2]] q=[%1 p=20]]]
    ~zod:dojo> `@tas`1.836.213.607
    %germ

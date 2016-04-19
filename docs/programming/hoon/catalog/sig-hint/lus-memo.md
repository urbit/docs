# `:memo`, `~+`, "siglus", `{$memo p/@ q/twig}`

Memoize computation.

Hints to the interpreter to memoize (cache) the computation of `p`.

Regular form: *1-fixed*

Examples:

    ~zod:dojo> 20
    20
    ~zod:dojo> ~+(20)
    20
    ~zod:dojo> 20
    ~zod:dojo> (make '20')
    [%1 p=20]
    ~zod:dojo> (make '~+(20)')
    [%10 p=[p=1.869.440.365 q=[%1 p=0]] q=[%1 p=20]]
    ~zod:dojo> `@tas`1.869.440.365
    %memo

By using `++make` to display the compiled nock, we can see that `~+`
inserts a `%memo` hint.

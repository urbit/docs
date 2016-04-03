# `:hint`, `~>` "siggar", {$hint p/$@(term {p/term q/twig}) q/twig}

Arbitrary hint

Applies arbitrary hint `p` to `q`.

Regular form: *2-fixed*

Examples:

    ~zod/try=> (make '~>(%a 42)')
    [%10 p=97 q=[%1 p=42]]
    ~zod/try=> (make '~>(%a.+(2) 42)')
    [%10 p=[p=97 q=[%4 p=[%1 p=2]]] q=[%1 p=42]]

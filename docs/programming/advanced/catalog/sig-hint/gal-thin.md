# `~<`, "siggal", `{$thin p/$@(term {p/term q/twig}) q/twig}`

Hint to product.

`~<` is a synthetic rune that applies arbitrary hint `p` to the
product of `q`. `~<` is similar to `~>`, but computes `q` before
applying the hint `p`.

Irregular form: *2-fixed*

Examples:

    ~zod:dojo> (make '~<(%a 42)')
    [%7 p=[%1 p=42] q=[%10 p=97 q=[%0 p=1]]]
    ~zod:dojo> (make '~<(%a.+(.) 42)')
    [%7 p=[%1 p=42] q=[%10 p=[p=97 q=[%4 p=[%0 p=1]]] q=[%0 p=1]]]

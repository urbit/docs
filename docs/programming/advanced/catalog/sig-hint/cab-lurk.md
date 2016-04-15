# `:lurk`, `~_`, "sigcab", `{$lurk p/twig q/twig}`

Pre-formatted stackframe into stacktrace.

Inserts pre-formatted stackframe `p` into the stacktrace of `q`. 
In hoon terminology, inserts `p`, a trap producing a ++`tank` (pretty printed text), in the trace of `q`.

Regular form: *2-fixed*

Examples:

    ~zod:dojo> (make '~_(+216 ~)')
    [%10 p=[p=1.851.876.717 q=[p=[%1 p=[0 216]] q=[%0 p=1]]] q=[%1 p=0]]
    ~zod:dojo> `@tas`1.851.876.717
    %mean

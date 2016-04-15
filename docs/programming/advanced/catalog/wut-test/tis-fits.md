# `:ifits`, `?=`, "wuttis" `{$fits p/twig q/wing}
====

Is `q` within type `p`.

Tests whether `q` is of mold `p`.

Regular form: *2-fixed*

Examples:

    ~zod:dojo> ?=(@ 'a')
    %.y
    ~zod:dojo> ?=(^ 'a')
    %.n
    ~zod:dojo> ?=(%b 'a')
    %.n
    ~zod:dojo> ?=(%a 'a')
    %.y

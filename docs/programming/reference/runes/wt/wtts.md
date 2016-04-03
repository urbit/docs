# `:ifits`, `?=`, "wuttis" `{$fits p/twig q/wing}
====

Is `q` within type `p`.

Tests whether `q` is of mold `p`.

Regular form: *2-fixed*

Examples:

    ~zod/try=> ?=(@ 'a')
    %.y
    ~zod/try=> ?=(^ 'a')
    %.n
    ~zod/try=> ?=(%b 'a')
    %.n
    ~zod/try=> ?=(%a 'a')
    %.y

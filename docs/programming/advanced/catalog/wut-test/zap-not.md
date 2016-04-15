# `:not`, `?!`, "wutzap" `{$not p/twig}`

Logical not.

Produces the logical "not" of `p`.

Regular form: *1-fixed*

Examples:

    ~zod:dojo> !&
    %.n
    ~zod:dojo> !|
    %.y
    ~zod:dojo> (gth 5 6)
    %.n
    ~zod:dojo> !(gth 5 6)
    %.y
    ~zod:dojo> !1
    ! type-fail
    ! exit

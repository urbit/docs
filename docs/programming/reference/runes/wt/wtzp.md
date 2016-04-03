# `:not`, `?!`, "wutzap" `{$not p/twig}`

Logical not.

Produces the logical "not" of `p`.

Regular form: *1-fixed*

Examples:

    ~zod/try=> !&
    %.n
    ~zod/try=> !|
    %.y
    ~zod/try=> (gth 5 6)
    %.n
    ~zod/try=> !(gth 5 6)
    %.y
    ~zod/try=> !1
    ! type-fail
    ! exit

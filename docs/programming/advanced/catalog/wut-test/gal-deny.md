# `:deny`, `?<`, "wutgal" `{$deny p/twig q/twig}`
====

Assert `p` is false.

Asserts that `p` is false before evaluating `q`. Crashes if `p` evaluates to false.

Regular form: *2-fixed*

Examples:

    ~zod:dojo> ?<(=(0x1 0) %foo)
    %foo
    ~zod:dojo> ?<(=(0x1 1) %foo)
    ! exit

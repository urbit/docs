# `:sure`, `?>`, "wutgar" `{$sure p/twig q/twig}`

Assert `p` is true.

Asserts that `p` is true before evaluating `q`, crashing if `p` evaluates to false.

Regular form: *2-fixed*

Examples:

    ~zod/try=> ?>(=(0x1 1) %foo)
    %foo
    ~zod/try=> ?>(=(0x1 0) %foo)
    ! exit

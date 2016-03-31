# `ifno`, `?~`, "wutsig" `{$ifno p/wing q/twig r/twig}`
====

If-null-then-else.

If-then-else statement that tests whether `p` is null, producing `q` if true
and `r` if false.

Regular form: *3-fixed*

Examples:

    ~zod/try=> ?~('a' 1 2)
    2
    ~zod/try=> ?~('' 1 2)
    1
    ~zod/try=> ?~(~zod 1 2)
    1
    ~zod/try=> ?~((sub 20 20) 1 2)
    1


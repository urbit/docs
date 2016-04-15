# `ifno`, `?~`, "wutsig" `{$ifno p/wing q/twig r/twig}`
====

If-null-then-else.

If-then-else statement that tests whether `p` is null, producing `q` if true
and `r` if false.

Regular form: *3-fixed*

Examples:

    ~zod:dojo> ?~('a' 1 2)
    2
    ~zod:dojo> ?~('' 1 2)
    1
    ~zod:dojo> ?~(~zod 1 2)
    1
    ~zod:dojo> ?~((sub 20 20) 1 2)
    1


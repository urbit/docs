# `:ifat`, `?&`, "wutpam" `{$ifat p/wing q/twig r/twig}`

If atom-then-else.

If-then-else statement that tests whether `p` is an atom, producing `q` if true and `r` if false.

Examples:

    ~zod:dojo> ?@(~ 1 2)
    ! mint-vain
    ! exit
    ~zod:dojo> ?@(%ha 1 2)
    1
    ~zod:dojo> ?@("" 1 2)
    1
    ~zod:dojo> ?@("a" 1 2)
    2
    ~zod:dojo> ?@([1 1] 1 2)
    ! mint-vain
    ! exit
    ~zod:dojo> ?@(`*`[1 1] 1 2)
    2 


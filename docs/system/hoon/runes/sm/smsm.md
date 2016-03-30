# `:fry`, `;;`, "semsem" `{$fry p/twig q/twig}`

Fixpoint.

Slams `q` through gate `p`, asserting that the
resulting noun is equal to `.=` the original, and produces it.

Examples: XX Review closely

    ~zod/try=> ^-(tape ~[97 98 99])
    ! type-fail
    ! exit
    ~zod/try=> ;;(tape ~[97 98 99])
    "abc"
    ~zod/try=> (tape [50 51 52])
    "23"
    ~zod/try=> ;;(tape [50 51 52])
    ! exit

# `:fry`, `;;`, "semsem" `{$fry p/twig q/twig}`

Fixpoint.

Slams `q` through gate `p`, asserting that the
resulting noun is equal to `.=` the original, and produces it.

Examples: XX Review closely

    ~zod:dojo> ^-(tape ~[97 98 99])
    ! type-fail
    ! exit
    ~zod:dojo> ;;(tape ~[97 98 99])
    "abc"
    ~zod:dojo> (tape [50 51 52])
    "23"
    ~zod:dojo> ;;(tape [50 51 52])
    ! exit

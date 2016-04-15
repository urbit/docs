# `:fail`, `!!`, "zapzap" `{$fail $~}`

Crash.

Always causes a crash. Frequently used as sentinel, especially when you don't want the type system to
give you type fails before you've written every possible branch of the
computation.

Regularm form: doesnt even accept input as it causes an immediate crash. XX???

Examples:

    ~zod:dojo> !!
    ! exit
    ~zod:dojo> =|(a=(unit) ?^(a !! %none))
    %none
    ~zod:dojo> :type; =|(a=(unit) ?^(a !! %none))
    %none
    %none
    ~zod:dojo> ?+('a' !! %a 1, %b 2)
    1
    ~zod:dojo> ?+('c' !! %a 1, %b 2)
    ! exit

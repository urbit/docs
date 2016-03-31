# `:fail`, `!!`, "zapzap" `{$fail $~}`

Crash.

Always causes a crash. Frequently used as sentinel, especially when you don't want the type system to
give you type fails before you've written every possible branch of the
computation.

Regularm form: doesnt even accept input as it causes an immediate crash. XX???

Examples:

    ~zod/try=> !!
    ! exit
    ~zod/try=> =|(a=(unit) ?^(a !! %none))
    %none
    ~zod/try=> :type; =|(a=(unit) ?^(a !! %none))
    %none
    %none
    ~zod/try=> ?+('a' !! %a 1, %b 2)
    1
    ~zod/try=> ?+('c' !! %a 1, %b 2)
    ! exit

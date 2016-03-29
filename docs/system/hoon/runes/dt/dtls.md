# `:bump`, `.+` "dotlus" `{$bump p/twig}`

Increments an atom.

Generates: nock operator `4`, which increments atom `p`.

Regular form: *1-fixed*

Irregular form:

`+(6)   .+(6)`

Examples

    ~zod/try=> +(6)
    7
    ~zod/try=> +(2)
    3

In the most straightforward case `.+` increments its operand.

    ~zod/try=> +(~zod)
    1
    /~zod/try=> `@`~zod
    0
    /~zod/try=> `@`'a'
    97    
    ~zod/try=> +('a')
    98
    /~zod/try=> `@`0xff
    255    
    ~zod/try=> +(0xff)
    256
    ~zod/try=> +(41)
    42

When passed a non-atomic odored atom `.+` down-casts to an atom (of just `@`).

    ~zod/try=> +([1 2])
    ! type-fail
    ! exit

Passing an operand that cannot be directly down-cast to an atom produces
a type-fail.

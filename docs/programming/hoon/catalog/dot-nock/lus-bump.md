# `:bump`, `.+` "dotlus" `{$bump p/twig}`

Increments an atom.

Generates: nock operator `4`, which increments atom `p`.

Regular form: *1-fixed*

Irregular form:

`+(6)   .+(6)`

Examples

    ~zod:dojo> +(6)
    7
    ~zod:dojo> +(2)
    3

In the most straightforward case `.+` increments its operand.

    ~zod:dojo> +(~zod)
    1
    /~zod:dojo> `@`~zod
    0
    /~zod:dojo> `@`'a'
    97    
    ~zod:dojo> +('a')
    98
    /~zod:dojo> `@`0xff
    255    
    ~zod:dojo> +(0xff)
    256
    ~zod:dojo> +(41)
    42

When passed a non-atomic odored atom `.+` down-casts to an atom (of just `@`).

    ~zod:dojo> +([1 2])
    ! type-fail
    ! exit

Passing an operand that cannot be directly down-cast to an atom produces
a type-fail.

---
sort: 9
---

`|+ barlus`
===========

Function with unreadable sample.

Produces:a dry `%iron` gate with argument (aka sample) `$*(p)` and arms
`q`. Similar to `|=`, but differs in that its input (sample) cannot be
read and thus cannot interfere with the type system.

Examples:

    ~zod/try=> +<:|+(a/@ a)
    ! -axis.6
    ! peek-park
    ! exit
    ~zod/try=> +<:|=(a/@ a)
    a=0

Here we're trying to read the sample, using the head of the tail of two different kinds of functions. With `|+` you can see we cause an error, whereas with `|=` our default sample is `a=0`.

    ~zod/try=> %.(20 |+(a/@ a))
    20
    ~zod/try=> %.(20 |=(a/@ a))
    20
    ~zod/try=> %.(20 |+(a/@ (add a 12)))
    32

Kicking a `|+` gate, however, is the same as `|=`.

# `:iron`, `^|`, "ketbar", `{$iron p/twig}`

Make core context unreadable.

Converts an %gold core `p` to an %iron core. Useful in preventing type
fails when replacing one core with one context with another core with a
different context.

Regular form: *1-fixed*

Examples:

    /~zod/try=> =cor  |=  a/@
          +(a)
    new var %cor
    /~zod/try=> +<.cor
    a=0
    /~zod/try=> =iro  ^|(cor)
    new var %iro
    /~zod/try=> +<.iro
    ! -axis.6
    ! peek-park
    ! exit

Here we crete a simple gate and assign it to the shell variable `cor`.
We can examine the sample of `cor` with `+<` (the head of the tail) to produce `a=0`. Assigning a new shell variable, `iro` as the `^|` of `cor` we can no longer peek in to its subject.

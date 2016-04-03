# `:peep`, `~!`, "sigzap", `{$peep p/twig q/twig}`

Print type on compilation fail.

Produces the type of `p` on the stacktrace if `q` fails. Used only for debugging purposes.

Examples:

    ~zod/try=> a
    ! -find-limb.a
    ! find-none
    ! exit
    ~zod/try=> ~!('foo' a)
    ! @t
    ! -find-limb.a
    ! find-none
    ! exit

When trying to compute an unassigned variable, `a` we produce the type
of `'foo'`, `@t`.

    ~zod/try=> ~!(%foo a)
    ! %foo
    ! -find-limb.a
    ! find-none
    ! exit

Again, we use our unassigned variable `a` and the cube `%foo`, whose
type is in fact `%foo`.

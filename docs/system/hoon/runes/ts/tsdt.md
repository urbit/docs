`=. tisdot`

Change value.

Produces `r` with `p` in the subject set to `q`. Allows you to change
a value in your subject before executing more code against it.

Regular form: *3-fixed*

Examples:

    ~zod/try=> =+  a=[b=1 c=2]
               =.  b.a  3
               a
    [b=3 c=2]
    ~zod/try=> =+  a=[b=1 c=2]
               =.(b.a 3 a)
    [b=3 c=2]

Here we see the tall and wide forms of `=.` used to manipulate our
simple subject `a=[b=1 c=2]`.

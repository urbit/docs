# `:like`, `^+`, "ketlus", `{$like p/twig q/twig}`

Cast `q` to an unbunted `p`.

Casts `q` to the type of `p`, verifying that it contains
the type of `q`. Similar to `^+`, but doesn't bunt `p`. Used to
cast to types that have previously been made into validator
functions (clams) with `$,`. For example, the arguments to a `|=` are
automatically bunted with a `=|`, so `^+` is used. Most often we use `^+` to cast when our type is already defined by something inside our context.

Regular form: *2 fixed*

Examples:

    ~zod:dojo> (add 90 7)
    97
    ~zod:dojo> ^+('any text' (add 90 7))
    'a'

Here we use a '++cord' (which could be any cord), `'any text'` to cast our
result to a cord.

    /~zod:dojo>  =cor  |=  a/{q/@ta r/@ s/@}
                       [(cat 3 'new' q.a) (add r.a s.a) (sub r.a s.a)]
    new var %cor
    /~zod:dojo> (cor 'start' 6 3)
    [8.390.876.208.525.960.558 9 3]
    /~zod:dojo>  =cor  |=  a/[q/@ta r/@ s/@]
                       ^+  a
                       [(cat 3 'new' q.a) (add r.a s.a) (sub r.a s.a)]
    changed %cor
    /~zod:dojo> (cor 'start' 6 3)
    [q=~.newstart r=9 s=3]

In this example we create a gate `cor` and lightly manipulate the tuple
it takes as a sample: we prepend `'new'` to its first member, produce
the sum of the latter two as the second, and the differene as the third.

In the first call you can see that our type information is lost, and we
produce our cord as an atom. By adding a `^+  a` we cast the result to
our input, and type information is retained.

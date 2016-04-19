# `:pin`, `=+`, "tislus" `{$pin p/twig q/twig}`

Push variable onto the subject.

Pushes a new variable `p` onto the subject and then executes `q` against it.
Can use `$=` to put an optional face (variable name) on the value.

Examples:

    ~zod:dojo> 
        =+  a=1
        a
    1

The simplest case of a `=+`, we push `a=1` on to our subject, and
produce `a`.

    ~zod:dojo> 
    =cor  |=  a=@
          =+  b=1
          =+  c=2
          :(add a b c)
    new var %cor
    ~zod:dojo> 
    (cor 0)
    3

This is a common case of `=+`, when we need to add intermediate values
to our subject to divide up our computation. `=+` makes for procedural,
top to bottom code organization.

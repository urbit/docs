# `:nip`, `=-`, "tishep" `{$nip p/twig q/twig}`

Inverted `=+`.

Pushes variable `q` onto the subject and then
executes `p` against the new subject.  Allows us to place the larger of `p` and
`q` as the bottom expression, making for for more readable code (see the
section on backstep in the syntax section).

Regular form: *2-fixed*

Examples:

    ~zod:dojo> =-  [%a a]
                   [a=1]
    [%a 1]

In this simple example we push `[a=1]` on to our subject, and produce
`[%a a]` which pulls the value of `a` from the subject producing
`[%a 1]`.

    ~zod:dojo> 
    =cor  |=  [a/@ b/@]
          =-  [[%a a] [%b b]]
          [a b]=[(add a 2) (add a b)]
    new var %cor
    ~zod:dojo> (cor 2 4)
    [[%a 4] %b 6]

Here we create a gate `cor` that takes two atoms `a` and `b`. We use
`=-` to put the product of our computation first.
